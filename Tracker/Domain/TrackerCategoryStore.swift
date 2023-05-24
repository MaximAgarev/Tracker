import Foundation
import CoreData

final class TrackerCategoryStore {
    
    let storage = TrackerStorageCoreData.shared
    let categoryRequest = TrackerCategoryCD.fetchRequest()
    var context: NSManagedObjectContext
    
    init() {
        context = storage.context
    }
    
    func getCategory(of title: String) -> TrackerCategoryCD {
        categoryRequest.predicate = NSPredicate(format: "title == %@", title)
        guard let categoryCD = try? context.fetch(categoryRequest).first else { return TrackerCategoryCD() }
        categoryRequest.predicate = nil
        return categoryCD
    }
    
    func getCategoryTitle(of trackerCD: TrackerCD) -> String {
        return trackerCD.category?.title ?? ""
    }
    
    func getCategoriesList() -> [String] {
        var categoriesList: [String] = []
        let categories = try? context.fetch(categoryRequest)
        categories?.forEach({ category in
            categoriesList.append(category.title ?? "")
        })
        return categoriesList
    }
    
    func checkCategoryExists(title: String) -> Bool {
        var categories: [TrackerCategoryCD] = []
        do {
            categories = try context.fetch(categoryRequest)
        }
        catch {
            assertionFailure("Couln't load categories from CoreData!")
        }
        for category in categories {
            if category.title == title { return true }
        }
        return false
    }
    
    func saveCategory(title: String) {
        let category = TrackerCategoryCD(context: context)
        category.title = title
        do {
            try context.save()
        }
        catch {
            assertionFailure("Couln't save categories to CoreData!")
        }
    }
    
    func updateCategory(editTitle: String, newTitle: String) {
        categoryRequest.predicate = NSPredicate(format: "title == %@", editTitle)
        let updateCategory = try? context.fetch(categoryRequest).first
        categoryRequest.predicate = nil
        updateCategory?.title = newTitle
        do {
            try context.save()
        }
        catch {
            assertionFailure("Couln't save categories to CoreData!")
        }
    }
    
    func deleteCategory(categoryTitle: String) {
        categoryRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        do {
            let deleteCategory = try context.fetch(categoryRequest)
            if !deleteCategory.isEmpty {
                TrackerStore().deleteTrackers(category: deleteCategory[0])
                context.delete(deleteCategory[0])
                try context.save()
            }
        }
        catch {
            assertionFailure("Couln't delete category \(categoryTitle) from CoreData!")
        }
        categoryRequest.predicate = nil
        storage.categoriesList = getCategoriesList()
    }
}
