import UIKit

struct Tracker: Hashable, Codable {
    var id: Int
    var title: String
    var schedule: String
    var emoji: String
    var color: Int
}

struct TrackerCategory: Equatable {
    var title: String
    var trackers: [Tracker]
    
    static func ==(lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        return lhs.title == rhs.title
    }
}

struct TrackerRecord: Hashable {
    var id: Int
    var tracker: Tracker
    var date: Date
}
