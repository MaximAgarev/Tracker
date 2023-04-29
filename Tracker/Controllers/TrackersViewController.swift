import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var trackersView: TrackersViewProtocol? { get set }
    
    var categories: [TrackerCategory] { get set }
    var visibleCategories: [TrackerCategory] { get set }
    
    func setView(fromStorage: Bool)
    func searchTrackers(text: String)
    func presentNewTrackerViewController()
}

class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    
    var trackersView: TrackersViewProtocol?
    
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationController = navigationController else { return }
                let trackersView = TrackersView(frame: .zero,
                                                viewController: self,
                                                navigationController: navigationController,
                                                navigationItem: navigationItem
                )
        trackersView.viewController = self
        self.trackersView = trackersView
        
        
        setView(fromStorage: true)
    }
    
    func setView(fromStorage: Bool) {
        if fromStorage {
            self.view = trackersView as? UIView
            let storage = TrackerStorage.shared
            categories = storage.loadCategories()
            visibleCategories = []
            categories.forEach {
                if $0.trackers.count != 0 { visibleCategories.append($0) }
            }
        }
        trackersView?.setTrackersCollection(isEmpty: visibleCategories.isEmpty)
    }
    
    func searchTrackers(text: String) {
        visibleCategories = []
        categories.forEach { category in
            var categoryInSearch = TrackerCategory(title: category.title, trackers: [])
            category.trackers.forEach { tracker in
                if tracker.title.lowercased().range(of: text.lowercased()) != nil {
                    categoryInSearch.trackers.append(tracker)
                }
            }
            if !visibleCategories.contains(categoryInSearch) {
                if !categoryInSearch.trackers.isEmpty { visibleCategories.append(categoryInSearch) }
            }
        }
        trackersView?.setTrackersCollection(isEmpty: visibleCategories.isEmpty)
    }
        
    func presentNewTrackerViewController() {
        let newTrackerViewController = ChoiceViewController()
        newTrackerViewController.modalPresentationStyle = .popover
        self.present(newTrackerViewController, animated: true)
    }
}
