import UIKit
import CoreData

protocol TrackerStorageProtocol {
    var delegate: AnyObject? { get set }
    
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    
    var categoriesList: [String] { get set }
    
    func fetchTrackers(date: Date?, searchText: String?)
    func getTracker(section: Int, index: Int) -> Tracker?
    func getCategoryTitle(section: Int) -> String
    func checkRecordExists(trackerID: Int, date: Date) -> Bool
    func checkCategoryExists(title: String) -> Bool
    func saveCategory(title: String)
    func updateCategory(editTitle: String, newTitle: String)
    
    func saveTracker(tracker: Tracker, categoryTitle: String)
    
//    func saveCategories(categories: [TrackerCategory])
    func deleteCategory(categoryTitle: String)
    func loadCompletedTrackers() -> Set<TrackerRecord>
    func saveCompletedTrackers(completedTrackers: Set<TrackerRecord>)
    func count() -> Int
    func trackerID() -> Int
}

final class TrackerStorageCoreData: NSObject, TrackerStorageProtocol {
    static let shared = TrackerStorageCoreData()
    private override init() {}
    
    weak var delegate: AnyObject?
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    func numberOfRowsInSection(_ section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    lazy var categoriesList: [String] = TrackerCategoryStore().getCategoriesList()
    
    let categoryRequest = TrackerCategoryCD.fetchRequest()
    let trackerRequest = TrackerCD.fetchRequest()
    let recordRequest = TrackerRecordCD.fetchRequest()
    let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
    
// MARK: - Container & FRC
    private lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "Tracker")
           container.loadPersistentStores { description, error in
               if let error = error {
                   fatalError("Unable to load persistent stores: \(error)")
               }
           }
           return container
       }()
    
    var context: NSManagedObjectContext {
          persistentContainer.viewContext
        }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCD> = {
        let fetchRequest = NSFetchRequest<TrackerCD>(entityName: "TrackerCD")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category", ascending: true),
            NSSortDescriptor(key: "title", ascending: true)
        ]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category",
            cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
// MARK: - Load categories & trackers
    func fetchTrackers(date: Date?, searchText: String?) {
        var predicates: [NSPredicate] = []
        
        if let date = date {
            var schedulePredicates: [NSPredicate] = []
            schedulePredicates.append(NSPredicate(format: "schedule CONTAINS %@", Weekday.everyDay))
            schedulePredicates.append(NSPredicate(format: "schedule == %@", ""))
            schedulePredicates.append(
                NSPredicate(format: "schedule CONTAINS[n] %@", Weekday.converted[Calendar.current.component(.weekday, from: date )])
            )
            let schedulePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: schedulePredicates)
            predicates.append(schedulePredicate)
        }
                
        if let searchText = searchText {
            let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
            predicates.append(searchPredicate)
        }
        
        if predicates.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: predicates
            )
        }
    
        try? fetchedResultsController.performFetch()
    }
    
    func getTracker(section: Int, index: Int) -> Tracker? {
        guard let tracker = fetchedResultsController.sections?[section].objects?[index] as? TrackerCD else { return nil }
        return TrackerStore().getTracker(tracker)
    }
    
    func getCategoryTitle(section: Int) -> String {
        guard let firstTracker = fetchedResultsController.sections?[section].objects?.first as? TrackerCD else { return "" }
        return TrackerCategoryStore().getCategoryTitle(of: firstTracker)
    }
    
    func checkRecordExists(trackerID: Int, date: Date) -> Bool {
        TrackerRecordStore().checkRecordExists(trackerID: trackerID, date: date)
    }
    
    func checkCategoryExists(title: String) -> Bool {
        TrackerCategoryStore().checkCategoryExists(title: title)
    }
    
// MARK: - Save categories & trackers
    func saveCategory(title: String) {
        TrackerCategoryStore().saveCategory(title: title)
        categoriesList = TrackerCategoryStore().getCategoriesList()
    }
    
    func updateCategory(editTitle: String, newTitle: String) {
        TrackerCategoryStore().updateCategory(editTitle: editTitle, newTitle: newTitle)
        categoriesList = TrackerCategoryStore().getCategoriesList()
    }
    
    func saveTracker(tracker: Tracker, categoryTitle: String) {
        let categoryCD = TrackerCategoryStore().getCategory(of: categoryTitle)
        TrackerStore().saveTracker(tracker: tracker, category: categoryCD)
    }

// MARK: - Delete categories & trackers
    func deleteCategory(categoryTitle: String) {
        TrackerCategoryStore().deleteCategory(categoryTitle: categoryTitle)
    }
    
// MARK: - Completed trackers
    func loadCompletedTrackers() -> Set<TrackerRecord> {
        var records: Set<TrackerRecord> = []
        var recordsFromStorage: [TrackerRecordCD] = []
        
        do {
            recordsFromStorage = try context.fetch(recordRequest)
        }
        catch {
            assertionFailure("Couln't load categories from CoreData!")
        }
        for recordCD in recordsFromStorage {
            records.insert(TrackerRecord(
                id: Int(recordCD.trackerID),
                date: recordCD.date ?? Date()
            ))
        }
        return records
    }
    
    func saveCompletedTrackers(completedTrackers: Set<TrackerRecord>) {
        for completedTracker in completedTrackers {
            addRecordToCompleted(id: completedTracker.id, date: completedTracker.date)
        }
        removeRecordFromCompleted(completedTrackers: completedTrackers)
    }
    
    func addRecordToCompleted(id: Int, date: Date) {
        recordRequest.predicate = NSPredicate(format: "trackerID == %d AND date == %@", Int64(id), date as CVarArg)
        do {
            let recordFromStorage = try context.fetch(recordRequest)
            if recordFromStorage.isEmpty {
                let newRecord = TrackerRecordCD(context: context)
                newRecord.trackerID = Int64(id)
                newRecord.date = date.withoutTime()
            }
            try context.save()
        }
        catch {
            assertionFailure("Couln't save completed trackers to CoreData!")
        }
        recordRequest.predicate = nil
    }

    func removeRecordFromCompleted(completedTrackers: Set<TrackerRecord>) {
        do {
            let recordsFromStorage = try context.fetch(recordRequest)
            for recordCD in recordsFromStorage {
                let record = TrackerRecord(
                    id: Int(recordCD.trackerID),
                    date: recordCD.date ?? Date()
                )
                if !completedTrackers.contains(record) {
                    context.delete(recordCD)
                }
            }
        }
        catch {
            assertionFailure("Couln't remove record from CoreData!")
        }
    }
    
// MARK: - Utilities
    func count() -> Int {
        var categoriesCount: Int = 0
        do {
            categoriesCount = try context.fetch(categoryRequest).count
        }
        catch {
            assertionFailure("Couln't count categories in CoreData!")
        }
        return categoriesCount
    }
    
    func trackerID() -> Int {
        var maxID = 0
        
        trackerRequest.predicate = nil
        let trackers = try? context.fetch(trackerRequest)
        guard var trackers = trackers else { return 0 }
        
        if !trackers.isEmpty {
            trackers.sort( by: { $0.trackerID > $1.trackerID } )
            maxID = Int(trackers[0].trackerID + 1)
        }
        
        return maxID
    }
}

extension TrackerStorageCoreData: NSFetchedResultsControllerDelegate {}
