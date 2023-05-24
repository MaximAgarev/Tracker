import UIKit
import CoreData

protocol TrackerStorageProtocol {
    var delegate: AnyObject? { get set }
    
    var categoriesList: [String] { get set }
    var numberOfSections: Int { get }
    
    func fetchTrackers(date: Date?, searchText: String?)
    func trackerID() -> Int
    func getTracker(section: Int, index: Int) -> Tracker?
    func saveTracker(tracker: Tracker, categoryTitle: String)
    
    func numberOfRowsInSection(_ section: Int) -> Int
    func getCategoryTitle(section: Int) -> String
    func checkCategoryExists(title: String) -> Bool
    func saveCategory(title: String)
    func updateCategory(editTitle: String, newTitle: String)
    func deleteCategory(categoryTitle: String)
    
    func checkRecordExists(trackerID: Int, date: Date) -> Bool
    func loadCompletedTrackers() -> Set<TrackerRecord>
    func saveCompletedTrackers(completedTrackers: Set<TrackerRecord>)
}

final class TrackerStorageCoreData: NSObject, TrackerStorageProtocol {
    static let shared = TrackerStorageCoreData()
    private override init() {}
    
    weak var delegate: AnyObject?
    
    lazy var trackerStore = TrackerStore()
    lazy var categoryStore = TrackerCategoryStore()
    lazy var recordStore = TrackerRecordStore()
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    lazy var categoriesList: [String] = categoryStore.getCategoriesList()
    
    
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
    
// MARK: - Trackers
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
    
    func trackerID() -> Int {
        trackerStore.trackerID()
    }
    
    func getTracker(section: Int, index: Int) -> Tracker? {
        guard let tracker = fetchedResultsController.sections?[section].objects?[index] as? TrackerCD else { return nil }
        return trackerStore.getTracker(tracker)
    }
    
    func saveTracker(tracker: Tracker, categoryTitle: String) {
        let categoryCD = TrackerCategoryStore().getCategory(of: categoryTitle)
        trackerStore.saveTracker(tracker: tracker, category: categoryCD)
    }

// MARK: - Categories
    func numberOfRowsInSection(_ section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func getCategoryTitle(section: Int) -> String {
        guard let firstTracker = fetchedResultsController.sections?[section].objects?.first as? TrackerCD else { return "" }
        return categoryStore.getCategoryTitle(of: firstTracker)
    }
    
    func checkCategoryExists(title: String) -> Bool {
        categoryStore.checkCategoryExists(title: title)
    }
    
    func saveCategory(title: String) {
        categoryStore.saveCategory(title: title)
    }
    
    func updateCategory(editTitle: String, newTitle: String) {
        categoryStore.updateCategory(editTitle: editTitle, newTitle: newTitle)
    }
    
    func deleteCategory(categoryTitle: String) {
        categoryStore.deleteCategory(categoryTitle: categoryTitle)
    }
    
// MARK: - Records

    func checkRecordExists(trackerID: Int, date: Date) -> Bool {
        recordStore.checkRecordExists(trackerID: trackerID, date: date)
    }

    func loadCompletedTrackers() -> Set<TrackerRecord> {
        recordStore.loadCompletedTrackers()
    }
    
    func saveCompletedTrackers(completedTrackers: Set<TrackerRecord>) {
        recordStore.saveCompletedTrackers(completedTrackers: completedTrackers)
    }
}

extension TrackerStorageCoreData: NSFetchedResultsControllerDelegate {}
