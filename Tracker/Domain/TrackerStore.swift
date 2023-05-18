import UIKit

final class TrackerStore {
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
}
