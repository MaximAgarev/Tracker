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
    
    func loadCategories() -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        var categoriesFromStorage: [TrackerCategoryCD] = []
        
        do {
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
            trackersFromStorage = try context.fetch(trackerRequest)
        }
        catch {
            assertionFailure("Couln't load trackers from CoreData!")
        }
        for trackerCD in trackersFromStorage {
            trackers.append(Tracker(
                id: Int(trackerCD.id),
                title: trackerCD.title ?? "",
                schedule: trackerCD.schedule ?? "",
                emoji: trackerCD.emoji ?? "",
                color: Int(trackerCD.color)
            ))
        }
        return trackers
    }
    
    func saveCategories(categories: [TrackerCategory]) {
        var searchCategory: [TrackerCategoryCD] = []
        for category in categories {
            categoryRequest.predicate = NSPredicate(format: "title == %@", category.title)
            do {
                searchCategory = try context.fetch(categoryRequest)
            }
            catch {
                assertionFailure("Couln't load categories from CoreData while saving!")
            }
            if searchCategory.isEmpty {
                let newCategory = TrackerCategoryCD(context: context)
                newCategory.title = category.title
            } else {
                for tracker in category.trackers {
                    saveTracker(tracker: tracker, category: searchCategory[0])
                    }
                }
            }
        do {
            try context.save()
        }
        catch {
            assertionFailure("Couln't save categories to CoreData!")
        }
        }

    
    func saveTracker(tracker: Tracker, category: TrackerCategoryCD) {
        trackerRequest.predicate = NSPredicate(format:"title == %@", tracker.title)
        let searchTracker = try! context.fetch(trackerRequest)
        if searchTracker.isEmpty {
            let newTracker = TrackerCD(context: context)
            newTracker.category = category
            newTracker.title = tracker.title
            newTracker.schedule = tracker.schedule
            newTracker.emoji = tracker.emoji
            newTracker.color = Int64(tracker.color)
        } else {
            let updatedTracker = searchTracker[0]
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
    }
    
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
    }
    
    func deleteTrackers(category: TrackerCategoryCD) {
        trackerRequest.predicate = NSPredicate(format: "category.title == %@", category.title!)
        do {
            let trackersFromStorage = try context.fetch(trackerRequest)
            if !trackersFromStorage.isEmpty {
                trackersFromStorage.forEach { tracker in
                    context.delete(tracker)
                }
            }
            try context.save()
        }
        catch {
            assertionFailure("Couln't load trackers from CoreData!")
        }
    }
    
    func loadCompletedTrackers() -> Set<TrackerRecord> {
        return []
    }
    
    func saveCompletedTrackers(completedTrackers: Set<TrackerRecord>) {
        
    }
    
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
        return 0
    }
    
    
    
}
