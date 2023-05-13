import UIKit
import CoreData

protocol TrackerStorageProtocol {
    func loadCategories() -> [TrackerCategory]
    func saveCategories(categories: [TrackerCategory])
    func deleteCategory(categoryTitle: String)
    func loadCompletedTrackers() -> Set<TrackerRecord>
    func saveCompletedTrackers(completedTrackers: Set<TrackerRecord>)
    func count() -> Int
    func trackerID() -> Int
}

final class TrackerStorageCoreData: TrackerStorageProtocol {
    static let shared = TrackerStorageCoreData()
    private init() {}
    
    let categoryRequest = TrackerCategoryCD.fetchRequest()
    let trackerRequest = TrackerCD.fetchRequest()
    let recordRequest = TrackerRecordCD.fetchRequest()
    let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
    
// MARK: - Container & context
    private lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "Tracker")
           container.loadPersistentStores { description, error in
               if let error = error {
                   fatalError("Unable to load persistent stores: \(error)")
               }
           }
           return container
       }()
    var readContext: NSManagedObjectContext {
          persistentContainer.viewContext
        }
    
// MARK: - Load categories & trackers
    func loadCategories() -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        var categoriesFromStorage: [TrackerCategoryCD] = []
        
        do {
            categoryRequest.sortDescriptors = [sortByTitle]
            categoriesFromStorage = try readContext.fetch(categoryRequest)
        }
        catch {
            assertionFailure("Couln't load categories from CoreData!")
        }
        for categoryCD in categoriesFromStorage {
            categories.append(TrackerCategory(
                title: categoryCD.title ?? "",
                trackers: loadTrackers(category: categoryCD)
            ))
        }
        return categories
    }
    
    func loadTrackers(category: TrackerCategoryCD) -> [Tracker] {
        var trackers: [Tracker] = []
        var trackersFromStorage: [TrackerCD] = []
        
        trackerRequest.predicate = NSPredicate(format: "category.title == %@", category.title!)
        do {
            trackerRequest.sortDescriptors = [sortByTitle]
            trackersFromStorage = try readContext.fetch(trackerRequest)
        }
        catch {
            assertionFailure("Couln't load trackers from CoreData!")
        }
        for trackerCD in trackersFromStorage {
            trackers.append(Tracker(
                id: Int((trackerCD.trackerID)),
                title: trackerCD.title ?? "",
                schedule: trackerCD.schedule ?? "",
                emoji: trackerCD.emoji ?? "",
                color: Int(trackerCD.color)
            ))
        }
        trackerRequest.predicate = nil
        return trackers
    }
    
// MARK: - Save categories & trackers
    func saveCategories(categories: [TrackerCategory]) {
        for category in categories {
            categoryRequest.predicate = NSPredicate(format: "title == %@", category.title)
            let searchCategory = try? readContext.fetch(categoryRequest).first
            
            if searchCategory == nil {
                let newCategory = TrackerCategoryCD(context: readContext)
                newCategory.title = category.title
                for tracker in category.trackers {
                    saveTracker(tracker: tracker, category: newCategory)
                }
            } else {
                for tracker in category.trackers {
                    saveTracker(tracker: tracker, category: searchCategory)
                }
            }
        }
        categoryRequest.predicate = nil
        do {
            try readContext.save()
        }
        catch {
            assertionFailure("Couln't save categories to CoreData!")
        }
    }
    
    
    func saveTracker(tracker: Tracker, category: TrackerCategoryCD?) {
        trackerRequest.predicate = NSPredicate(format:"title == %@", tracker.title)
        guard let searchTracker = try? readContext.fetch(trackerRequest) else { return }
        if searchTracker.isEmpty {
            let newTracker = TrackerCD(context: readContext)
            newTracker.trackerID = Int64(trackerID())
            newTracker.category = category
            newTracker.title = tracker.title
            newTracker.schedule = tracker.schedule
            newTracker.emoji = tracker.emoji
            newTracker.color = Int64(tracker.color)
        } else if let updatedTracker = searchTracker.first(where: { $0.category?.title == category?.title }) {
            updatedTracker.trackerID = Int64(tracker.id)
            updatedTracker.category = category
            updatedTracker.title = tracker.title
            updatedTracker.schedule = tracker.schedule
            updatedTracker.emoji = tracker.emoji
            updatedTracker.color = Int64(tracker.color)
        }
        trackerRequest.predicate = nil
        do {
            try readContext.save()
        }
        catch {
            assertionFailure("Couln't save trackers to CoreData!")
        }
    }

// MARK: - Delete categories & trackers
    func deleteCategory(categoryTitle: String) {
        categoryRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        do {
            let deleteCategory = try readContext.fetch(categoryRequest)
            if !deleteCategory.isEmpty {
                deleteTrackers(category: deleteCategory[0])
                readContext.delete(deleteCategory[0])
                try readContext.save()
            }
        }
        catch {
            assertionFailure("Couln't delete category \(categoryTitle) from CoreData!")
        }
        categoryRequest.predicate = nil
    }
    
    func deleteTrackers(category: TrackerCategoryCD) {
        guard let title = category.title else { return }
        trackerRequest.predicate = NSPredicate(format: "category.title == %@", title)
        do {
            let trackersFromStorage = try readContext.fetch(trackerRequest)
            if !trackersFromStorage.isEmpty {
                trackersFromStorage.forEach { tracker in
                    readContext.delete(tracker)
                    removeDeletedTrackerRecords(id: tracker.trackerID)
                }
            }
            try readContext.save()
        }
        catch {
            assertionFailure("Couln't delete trackers from CoreData!")
        }
        trackerRequest.predicate = nil
    }
    
// MARK: - Completed trackers
    func loadCompletedTrackers() -> Set<TrackerRecord> {
        var records: Set<TrackerRecord> = []
        var recordsFromStorage: [TrackerRecordCD] = []
        
        do {
            recordsFromStorage = try readContext.fetch(recordRequest)
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
            let recordFromStorage = try readContext.fetch(recordRequest)
            if recordFromStorage.isEmpty {
                let newRecord = TrackerRecordCD(context: readContext)
                newRecord.trackerID = Int64(id)
                newRecord.date = date.withoutTime()
            }
            try readContext.save()
        }
        catch {
            assertionFailure("Couln't save completed trackers to CoreData!")
        }
        recordRequest.predicate = nil
    }

    func removeRecordFromCompleted(completedTrackers: Set<TrackerRecord>) {
        do {
            let recordsFromStorage = try readContext.fetch(recordRequest)
            for recordCD in recordsFromStorage {
                let record = TrackerRecord(
                    id: Int(recordCD.trackerID),
                    date: recordCD.date ?? Date()
                )
                if !completedTrackers.contains(record) {
                    readContext.delete(recordCD)
                }
            }
        }
        catch {
            assertionFailure("Couln't remove record from CoreData!")
        }
    }
    
    func removeDeletedTrackerRecords(id: Int64) {
        recordRequest.predicate = NSPredicate(format: "trackerID == %d", id)
        do {
            let recordsFromStorage = try readContext.fetch(recordRequest)
            recordsFromStorage.forEach { record in
                readContext.delete(record)
            }
            try readContext.save()
        }
        catch {
            assertionFailure("Couln't delete tracker records from CoreData!")
        }
        recordRequest.predicate = nil
    }
    
// MARK: - Utilities
    func count() -> Int {
        var categoriesCount: Int = 0
        do {
            categoriesCount = try readContext.fetch(categoryRequest).count
        }
        catch {
            assertionFailure("Couln't count categories in CoreData!")
        }
        return categoriesCount
    }
    
    func trackerID() -> Int {
        var maxID = 0
        
        trackerRequest.predicate = nil
        let trackers = try? readContext.fetch(trackerRequest)
        guard var trackers = trackers else { return 0 }
        
        if !trackers.isEmpty {
            trackers.sort( by: { $0.trackerID > $1.trackerID } )
            maxID = Int(trackers[0].trackerID + 1)
        }
        
        return maxID
    }
}
