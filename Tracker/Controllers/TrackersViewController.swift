import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var trackersView: TrackersViewProtocol? { get set }
    
    var categories: [TrackerCategory] { get set }
    var currentDate: Date { get set }
    var visibleCategories: [TrackerCategory] { get set }
    
    func setView()
    func searchTrackers(text: String)
    func presentNewTrackerViewController()
}

class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    
    var trackersView: TrackersViewProtocol?
    
    var categories: [TrackerCategory] = []
    var currentDate: Date = Date()
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setView),
            name: NSNotification.Name(rawValue: "updateTrackers"),
            object: nil
        )
        
        setView()
    }
    
    @objc
    func setView() {
        self.view = trackersView as? UIView
        let storage = TrackerStorage.shared
        categories = storage.loadCategories()
        
        visibleCategories = filterByWeekday(categories: categories)
        trackersView?.setTrackersCollection()
    }
    
    func filterByWeekday(categories: [TrackerCategory]) -> [TrackerCategory] {
        var filteredCategories: [TrackerCategory] = []
        categories.forEach { category in
            var categoryInFilter = TrackerCategory(title: category.title, trackers: [])
            category.trackers.forEach { tracker in
                if tracker.schedule == "" {
                    categoryInFilter.trackers.append(tracker)
                } else {
                    let currentWeekday = Weekday.converted[Calendar.current.component(.weekday, from: currentDate)]
                    if tracker.schedule.range(of: currentWeekday) != nil {
                        categoryInFilter.trackers.append(tracker)
                    }
                }
            }
            if !categoryInFilter.trackers.isEmpty { filteredCategories.append(categoryInFilter) }
            }
        return filteredCategories
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
        visibleCategories = filterByWeekday(categories: visibleCategories)
        trackersView?.setTrackersCollection()
    }
        
    func presentNewTrackerViewController() {
        let newTrackerViewController = ChoiceViewController()
        newTrackerViewController.modalPresentationStyle = .popover
        self.present(newTrackerViewController, animated: true)
    }
}
