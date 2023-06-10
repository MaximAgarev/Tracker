import UIKit
import CoreData

protocol TrackerStorageProtocol {
    var categoriesList: [String] { get set }
    var numberOfSections: Int { get }
    
    func fetchTrackers(date: Date?, searchText: String?)
    func trackerID() -> Int
    func getTracker(section: Int, row: Int) -> Tracker?
    func getTrackerUnpinnedCategory(section: Int, row: Int) -> String
    func saveTracker(tracker: Tracker, categoryTitle: String)
    func checkPinStatus(section: Int, row: Int) -> Bool
    func pinTracker(section: Int, row: Int)
    func deleteTracker(section: Int, row: Int)
    
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
    
    func getTracker(section: Int, row: Int) -> Tracker? {
        guard let tracker = fetchedResultsController.sections?[section].objects?[row] as? TrackerCD else { return nil }
        return trackerStore.getTracker(tracker)
    }
    
    func getTrackerUnpinnedCategory(section: Int, row: Int) -> String {
        guard let tracker = fetchedResultsController.sections?[section].objects?[row] as? TrackerCD,
              let title = tracker.category?.title else { return "" }
        if title == "Закрепленные" { return tracker.pinnedFrom ?? "" }
        return title
    }
    
    func saveTracker(tracker: Tracker, categoryTitle: String) {
        let categoryCD = TrackerCategoryStore().getCategory(of: categoryTitle)
        trackerStore.saveTracker(tracker: tracker, category: categoryCD)
        try? fetchedResultsController.performFetch()
    }
    
    func checkPinStatus(section: Int, row: Int) -> Bool {
        guard let tracker = fetchedResultsController.sections?[section].objects?[row] as? TrackerCD else { return false }
        return tracker.pinnedFrom != nil
    }
    
    func pinTracker(section: Int, row: Int) {
        guard let tracker = fetchedResultsController.sections?[section].objects?[row] as? TrackerCD else { return }
        trackerStore.pinTracker(trackerCD: tracker)
    }
    
    func deleteTracker(section: Int, row: Int) {
        guard let tracker = fetchedResultsController.sections?[section].objects?[row] as? TrackerCD else { return }
        trackerStore.deleteTracker(trackerCD: tracker)
        recordStore.removeDeletedTrackerRecords(id: tracker.trackerID)
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
        try? fetchedResultsController.performFetch()
    }
    
    func updateCategory(editTitle: String, newTitle: String) {
        categoryStore.updateCategory(editTitle: editTitle, newTitle: newTitle)
        try? fetchedResultsController.performFetch()
    }
    
    func deleteCategory(categoryTitle: String) {
        categoryStore.deleteCategory(categoryTitle: categoryTitle)
        try? fetchedResultsController.performFetch()
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
        try? fetchedResultsController.performFetch()
    }
}

extension TrackerStorageCoreData: NSFetchedResultsControllerDelegate {}
