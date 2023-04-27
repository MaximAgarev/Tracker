import UIKit

struct Tracker: Hashable, Codable {
    var id: Int
    var title: String
    var schedule: String
    var emoji: String
    var color: Int
}

struct TrackerCategory {
    var title: String
    var trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    var id: Int
    var tracker: Tracker
    var date: Date
}
