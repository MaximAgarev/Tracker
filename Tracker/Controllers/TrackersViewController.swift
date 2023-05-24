import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var trackersView: TrackersViewProtocol? { get set }
    var storage: TrackerStorageProtocol? { get set }
    
    var currentDate: Date { get set }
    var completedTrackers: Set<TrackerRecord> { get set }
    
    func setView()
    func searchTrackers(text: String)
    func trackButtonDidTap(trackerID: Int)
    func presentNewTrackerViewController()
}

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    var trackersView: TrackersViewProtocol?
    var storage: TrackerStorageProtocol?
    
    var categories: [TrackerCategory] = []
    var currentDate: Date = Date().withoutTime()
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

        storage = TrackerStorageCoreData.shared
        storage?.delegate = self
        
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
    
    func presentNewTrackerViewController() {
        let newTrackerViewController = ChoiceViewController()
        newTrackerViewController.modalPresentationStyle = .popover
        self.present(newTrackerViewController, animated: true)
    }
}
