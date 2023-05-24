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
            updatedTracker.category = category
            updatedTracker.title = tracker.title
            updatedTracker.schedule = tracker.schedule
            updatedTracker.emoji = tracker.emoji
            updatedTracker.color = Int64(tracker.color)
        }
        
        do {
            try context.save()
        }
        catch {
            assertionFailure("Couln't save trackers to CoreData!")
        }
        trackerRequest.predicate = nil
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
            assertionFailure("Couln't delete trackers from CoreData!")
        }
        trackerRequest.predicate = nil
    }
}