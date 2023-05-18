import Foundation

class TrackerStorage {
//    static let shared = TrackerStorage()
//    private init() {}
//    
//    private var storage = UserDefaults.standard
//    private var categoriesKey = "categories"
//    private var recordsKey = "records"
//    
//    private enum CategoryKey: String {
//        case title
//        case trackers
//    }
//    
//    private enum RecordKey: String {
//        case id
//        case date
//    }
//        
//    func loadCategories() -> [TrackerCategory] {
//        var result: [TrackerCategory] = []
//        let categoriesFromStorage = storage.array(forKey: categoriesKey) as? [[String:Any]] ?? []
//        for category in categoriesFromStorage {
//            guard let title = category[CategoryKey.title.rawValue] as? String else { continue }
//            if let trackers = category[CategoryKey.trackers.rawValue] as? Data {
//                guard let decodedTrackers = try? JSONDecoder().decode([Tracker].self, from: trackers) else { return [] }
//                result.append(TrackerCategory(title: title, trackers: decodedTrackers))
//            } else {
//                result.append(TrackerCategory(title: title, trackers: []))
//            }
//        }
//        return result
//    }
//    
//    func saveCategories(categories: [TrackerCategory]) {
//        var categoriesForStorage: [[String: Any]] = []
//        categories.forEach { category in
//            var newElementForStorage: Dictionary<String, Any> = [:]
//            let encodedtrackers = try? JSONEncoder().encode(category.trackers)
//            newElementForStorage[CategoryKey.title.rawValue] = category.title
//            newElementForStorage[CategoryKey.trackers.rawValue] = encodedtrackers
//            categoriesForStorage.append(newElementForStorage)
//        }
//        storage.set(categoriesForStorage, forKey: categoriesKey)
//    }
//    
//    func deleteCategory(categoryTitle: String) {
//        var result: [[String:Any]] = []
//        let categoriesFromStorage = storage.array(forKey: categoriesKey) as? [[String:Any]] ?? []
//        for category in categoriesFromStorage {
//            guard let storedCategory = category[CategoryKey.title.rawValue] as? String else { return }
//            if storedCategory != categoryTitle {
//                result.append(category)
//            }
//            
//        }
//        storage.set(result, forKey: categoriesKey)
//    }
//    
//    func loadCompletedTrackers() -> Set<TrackerRecord> {
//        var result: Set<TrackerRecord> = []
//        let recordsFromStorage = storage.array(forKey: recordsKey) as? [[String:Any]] ?? []
//        for record in recordsFromStorage {
//            guard let id = record[RecordKey.id.rawValue] as? Int else { continue }
//            guard let date = record[RecordKey.date.rawValue] as? Date else { continue }
//            result.insert(TrackerRecord(id: id, date: date))
//        }
//        return result
//    }
//    
//    func saveCompletedTrackers(completedTrackers: Set<TrackerRecord>) {
//        var recordsForStorage: [[String: Any]] = []
//        completedTrackers.forEach { record in
//            var newElementForStorage: Dictionary<String, Any> = [:]
//            newElementForStorage[RecordKey.id.rawValue] = record.id
//            newElementForStorage[RecordKey.date.rawValue] = record.date
//            recordsForStorage.insert(newElementForStorage, at: recordsForStorage.count)
//        }
//        storage.set(recordsForStorage, forKey: recordsKey)
//    }
//    
//    func count() -> Int {
//        let categoriesFromStorage = storage.array(forKey: categoriesKey)
//        return categoriesFromStorage?.count ?? 0
//    }
//    
//    func trackerID() -> Int {
//        let trackerID = storage.integer(forKey: "trackerID") + 1
//        storage.set(trackerID, forKey: "trackerID")
//        return trackerID
//    }
}
