import UIKit

struct Tracker: Hashable {
    let id: UInt
    let title: String
    let color: UIColor
    let emoji: String?
    let schedule: String?
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    let id: UInt
    let tracker: Tracker
    let date: Date
}
