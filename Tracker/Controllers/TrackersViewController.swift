import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var trackersView: TrackersViewProtocol? { get set }
    var storage: TrackerStorageProtocol? { get set }
    
    var currentDate: Date { get set }
    var completedTrackers: Set<TrackerRecord> { get set }
    
    func setView()
    func searchTrackers(text: String)
    func trackButtonDidTap(trackerID: Int)
    func presentChoiceViewController()
    func presentEditTrackerViewController(tracker: Tracker, category: String)
    func checkPinStatus(indexPath: IndexPath) -> Bool
    func pinTracker(indexPath: IndexPath)
    func deleteTracker(indexPath: IndexPath)
}

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    var trackersView: TrackersViewProtocol?
    var storage: TrackerStorageProtocol?
    
    var categories: [TrackerCategory] = []
    var currentDate: Date = Date().withoutTime()
    var completedTrackers: Set<TrackerRecord> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLaunchOnboarding()
        
        guard let navigationController = navigationController else { return }
        let trackersView = TrackersView(frame: .zero,
                                        viewController: self,
                                        navigationController: navigationController,
                                        navigationItem: navigationItem
        )
        trackersView.viewController = self
        self.trackersView = trackersView

        storage = TrackerStorageCoreData.shared
        
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
        storage.fetchTrackers(date: currentDate, searchText: nil)

        completedTrackers = storage.loadCompletedTrackers()
        
        trackersView?.setTrackersCollection()
    }
    
    func searchTrackers(text: String) {
        storage?.fetchTrackers(date: currentDate, searchText: text)
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
    
    func presentChoiceViewController() {
        let choiceViewController = ChoiceViewController()
        choiceViewController.modalPresentationStyle = .popover
        self.present(choiceViewController, animated: true)
    }
    
    func presentEditTrackerViewController(tracker: Tracker, category: String) {
        let editTrackerViewController = NewTrackerViewController()
        editTrackerViewController.editTracker = tracker
        editTrackerViewController.category = category
        self.present(editTrackerViewController, animated: true)
    }
    
    func firstLaunchOnboarding() {
        let onboardingKey = "isOnboarded"
        if !UserDefaults.standard.bool(forKey: onboardingKey) {
            let onboardingViewController = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: nil)
            onboardingViewController.modalPresentationStyle = .fullScreen
            self.view.window?.rootViewController?.present(onboardingViewController, animated: false)
            UserDefaults.standard.set(true, forKey: onboardingKey)
        }
    }
    
    func checkPinStatus(indexPath: IndexPath) -> Bool {
        return storage?.checkPinStatus(section: indexPath.section, row: indexPath.row) ?? false
    }
    
    func pinTracker(indexPath: IndexPath) {
        storage?.pinTracker(section: indexPath.section, row: indexPath.row)
        setView()
    }
    
    func deleteTracker(indexPath: IndexPath) {
        storage?.deleteTracker(section: indexPath.section, row: indexPath.row)
        setView()
    }
}
