import UIKit

final class CategoriesViewModel {
    var onChange: (() -> Void)?
    
    private(set) var categories: [String] = [] {
        didSet {
            onChange?()
        }
    }
    
    private let storage: TrackerStorageCoreData
    
    init() {
        self.storage = TrackerStorageCoreData.shared
        categories = storage.categoriesList
    }
    
    func checkCategoryExists(title: String) -> Bool {
        storage.checkCategoryExists(title: title)
    }
    
    func saveCategory(title: String) {
        storage.saveCategory(title: title)
        categories = storage.categoriesList
    }
    
    func updateCategory(editTitle: String, newTitle: String) {
        storage.updateCategory(editTitle: editTitle, newTitle: newTitle)
        categories = storage.categoriesList
    }
    
    func deleteCategory(categoryTitle: String) {
        storage.deleteCategory(categoryTitle: categoryTitle)
        categories = storage.categoriesList
    }
    
    
}
