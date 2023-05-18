import UIKit

final class TrackerCategoryStore {
    
    func getCategoryTitle(of trackerCD: TrackerCD) -> String {
        return trackerCD.category?.title ?? ""
    }
}
