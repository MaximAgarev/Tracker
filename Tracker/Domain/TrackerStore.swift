import Foundation
import CoreData

final class TrackerStore {
    let storage = TrackerStorageCoreData.shared
    let trackerRequest = TrackerCD.fetchRequest()
    var context: NSManagedObjectContext
    
    init() {
        context = storage.context
    }
    
    func getTracker(_ trackerCD: TrackerCD) -> Tracker {
        let tracker = Tracker(
            id: Int((trackerCD.trackerID)),
            title: trackerCD.title ?? "",
            schedule: trackerCD.schedule ?? "",
            emoji: trackerCD.emoji ?? "",
            color: Int(trackerCD.color)
        )
        return tracker
    }
    
    func saveTracker(tracker: Tracker, category: TrackerCategoryCD) {
        trackerRequest.predicate = NSPredicate(format:"trackerID == %i", tracker.id)
        guard let searchTracker = try? context.fetch(trackerRequest) else { return }
        
        if searchTracker.isEmpty {
            let newTracker = TrackerCD(context: context)
            newTracker.trackerID = Int64(storage.trackerID())
            newTracker.category = category
            newTracker.title = tracker.title
            newTracker.schedule = tracker.schedule
            newTracker.emoji = tracker.emoji
            newTracker.color = Int64(tracker.color)
        } else if let updatedTracker = searchTracker.first(where: { $0.trackerID == Int64(tracker.id) }) {
            if updatedTracker.pinnedFrom != nil {
                updatedTracker.pinnedFrom = category.title
                updatedTracker.category = TrackerCategoryStore().getCategory(of: "Закрепленные")
            } else {
                updatedTracker.category = category
            }
            updatedTracker.title = tracker.title
            updatedTracker.schedule = tracker.schedule
            updatedTracker.emoji = tracker.emoji
            updatedTracker.color = Int64(tracker.color)
        }
        
        do {
            try context.save()
        }
        catch {
            assertionFailure("Couln't save tracker to CoreData")
        }
        trackerRequest.predicate = nil
    }
    
    func deleteTracker(trackerCD: TrackerCD) {
        context.delete(trackerCD)
        try? context.save()
    }
    
    func pinTracker(trackerCD: TrackerCD) {
        if let pinnedTracker = trackerCD.pinnedFrom {
            let unpinnedCategory = TrackerCategoryStore().getCategory(of: pinnedTracker)
            trackerCD.category = unpinnedCategory
            trackerCD.pinnedFrom = nil
            try? context.save()
        } else {
            let pinnedCategory = TrackerCategoryStore().getPinnedCategory()
            trackerCD.pinnedFrom = trackerCD.category?.title
            trackerCD.category = pinnedCategory
            try? context.save()
        }
    }
    
    func deleteTrackers(category: TrackerCategoryCD) {
        guard let title = category.title else { return }
        trackerRequest.predicate = NSPredicate(format: "category.title == %@", title)
        do {
            let trackersFromStorage = try context.fetch(trackerRequest)
            if !trackersFromStorage.isEmpty {
                trackersFromStorage.forEach { tracker in
                    context.delete(tracker)
                    TrackerRecordStore().removeDeletedTrackerRecords(id: tracker.trackerID)
                }
            }
            try context.save()
        }
        catch {
            assertionFailure("Couln't delete trackers from CoreData")
        }
        trackerRequest.predicate = nil
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
