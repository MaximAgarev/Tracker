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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let categoryRequest = TrackerCategoryCD.fetchRequest()
    let trackerRequest = TrackerCD.fetchRequest()
    let recordRequest = TrackerRecordCD.fetchRequest()
    let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
    
// MARK: - Load categories & trackers
    func loadCategories() -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        var categoriesFromStorage: [TrackerCategoryCD] = []
        
        do {
            categoryRequest.sortDescriptors = [sortByTitle]
            categoriesFromStorage = try context.fetch(categoryRequest)
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
            trackersFromStorage = try context.fetch(trackerRequest)
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
            let searchCategory = try? context.fetch(categoryRequest).first
            
            if searchCategory == nil {
                let newCategory = TrackerCategoryCD(context: context)
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
            try context.save()
        }
        catch {
            assertionFailure("Couln't save categories to CoreData!")
        }
    }
    
    
    func saveTracker(tracker: Tracker, category: TrackerCategoryCD?) {
        trackerRequest.predicate = NSPredicate(format:"title == %@", tracker.title)
        let searchTracker = try! context.fetch(trackerRequest)
        if searchTracker.isEmpty {
            let newTracker = TrackerCD(context: context)
            newTracker.trackerID = Int64(trackerID())
            newTracker.category = category
            newTracker.title = tracker.title
            newTracker.schedule = tracker.schedule
            newTracker.emoji = tracker.emoji
            newTracker.color = Int64(tracker.color)
        } else {
            let updatedTracker = searchTracker.first(where: { $0.category?.title == category?.title })
            updatedTracker?.trackerID = Int64(tracker.id)
            updatedTracker?.category = category
            updatedTracker?.title = tracker.title
            updatedTracker?.schedule = tracker.schedule
            updatedTracker?.emoji = tracker.emoji
            updatedTracker?.color = Int64(tracker.color)
        }
        trackerRequest.predicate = nil
        do {
            try context.save()
        }
        catch {
            assertionFailure("Couln't save trackers to CoreData!")
        }
    }

// MARK: - Delete categories & trackers
    func deleteCategory(categoryTitle: String) {
        categoryRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        do {
            let deleteCategory = try context.fetch(categoryRequest)
            if !deleteCategory.isEmpty {
                deleteTrackers(category: deleteCategory[0])
                context.delete(deleteCategory[0])
                try context.save()
            }
        }
        catch {
            assertionFailure("Couln't delete category \(categoryTitle) from CoreData!")
        }
        categoryRequest.predicate = nil
    }
    
    func deleteTrackers(category: TrackerCategoryCD) {
        trackerRequest.predicate = NSPredicate(format: "category.title == %@", category.title!)
        do {
            let trackersFromStorage = try context.fetch(trackerRequest)
            if !trackersFromStorage.isEmpty {
                trackersFromStorage.forEach { tracker in
                    context.delete(tracker)
                    removeDeletedTrackerRecords(id: tracker.trackerID)
                }
            }
            try context.save()
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
    
    func removeDeletedTrackerRecords(id: Int64) {
        recordRequest.predicate = NSPredicate(format: "trackerID == %d", id)
        do {
            let recordsFromStorage = try context.fetch(recordRequest)
            recordsFromStorage.forEach { record in
                context.delete(record)
            }
            try context.save()
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
