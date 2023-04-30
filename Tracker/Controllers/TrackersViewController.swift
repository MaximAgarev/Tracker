import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var trackersView: TrackersViewProtocol? { get set }
    var storage: TrackerStorageProtocol? { get set }
    
    var categories: [TrackerCategory] { get set }
    var currentDate: Date { get set }
    var visibleCategories: [TrackerCategory] { get set }
    var completedTrackers: Set<TrackerRecord> { get set }
    
    func setView()
    func searchTrackers(text: String)
    func trackButtonDidTap(trackerID: Int)
    func presentNewTrackerViewController()
}

class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    
    var trackersView: TrackersViewProtocol?
    var storage: TrackerStorageProtocol?
    
    var categories: [TrackerCategory] = []
    var currentDate: Date = Date().withoutTime()
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
        storage = TrackerStorage.shared
        
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
        
        guard let storage = storage else { return }
        categories = storage.loadCategories()
        completedTrackers = storage.loadCompletedTrackers()
        
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
    
    func trackButtonDidTap(trackerID: Int) {
        let trackerRecord = TrackerRecord(id: trackerID, date: currentDate.withoutTime())
        if completedTrackers.contains(trackerRecord) {
            completedTrackers.remove(trackerRecord)
        } else {
            completedTrackers.insert(trackerRecord)
        }
        guard let storage = storage else { return }
        storage.saveCompletedTrackers(completedTrackers: completedTrackers)
        setView()
    }
        
    func presentNewTrackerViewController() {
        let newTrackerViewController = ChoiceViewController()
        newTrackerViewController.modalPresentationStyle = .popover
        self.present(newTrackerViewController, animated: true)
    }
}
