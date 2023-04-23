import Foundation

protocol TrackerStorageProtocol {
    func loadCategories() -> [TrackerCategory]
    func saveCategories(categories: [TrackerCategory])
    func deleteCategory(categoryTitle: String)
    func count() -> Int
}

class TrackerStorage: TrackerStorageProtocol {
    static let shared = TrackerStorage()
    private init() {}
    
    private var storage = UserDefaults.standard
    private var categoriesKey = "categories"
    
    private enum CategoryKey: String {
        case title
        case trackers
    }

    func loadCategories() -> [TrackerCategory] {
        var result: [TrackerCategory] = []
        let categoriesFromStorage = storage.array(forKey: categoriesKey) as? [[String:Any]] ?? []
        
        for category in categoriesFromStorage {
            guard let title = category[CategoryKey.title.rawValue] as? String,
                  let trackers = category[CategoryKey.trackers.rawValue] as? [Tracker] else { continue }
            result.append(TrackerCategory(title: title, trackers: trackers))
        }
        
        return result
        }
    
    func saveCategories(categories: [TrackerCategory]) {
        var categoriesForStorage: [[String: Any]] = []
        categories.forEach { category in
            var newElementForStorage: Dictionary<String, Any> = [:]
            newElementForStorage[CategoryKey.title.rawValue] = category.title
            newElementForStorage[CategoryKey.trackers.rawValue] = category.trackers
            categoriesForStorage.append(newElementForStorage)
        }
        storage.set(categoriesForStorage, forKey: categoriesKey)
    }
    
    func deleteCategory(categoryTitle: String) {
        var result: [[String:Any]] = []
        var categoriesFromStorage = storage.array(forKey: categoriesKey) as? [[String:Any]] ?? []
        for category in categoriesFromStorage {
            guard let storedCategory = category[CategoryKey.title.rawValue] as? String else { return }
            if storedCategory != categoryTitle {
                result.append(category)
            }
            
        }
        storage.set(result, forKey: categoriesKey)
    }
    
    func count() -> Int {
        let categoriesFromStorage = storage.array(forKey: categoriesKey)
        return categoriesFromStorage?.count ?? 0
    }
    
    
}
