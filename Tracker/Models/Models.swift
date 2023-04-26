import UIKit

struct Tracker: Hashable {
    var id: UInt
    var title: String
    var color: UIColor
    var emoji: String?
    var schedule: String?
}

struct TrackerCategory {
    var title: String
    var trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    var id: UInt
    var tracker: Tracker
    var date: Date
}
