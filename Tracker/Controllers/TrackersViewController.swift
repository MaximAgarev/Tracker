import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var trackersView: TrackersViewProtocol? { get set }
    
    var categories: [TrackerCategory] { get set }
    var visibleCategories: [TrackerCategory] { get set }
    
    func presentNewTrackerViewController()
}

class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    
    var trackersView: TrackersViewProtocol?
    
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make NavBar on View
        guard let navigationController = navigationController else { return }
                let trackersView = TrackersView(frame: .zero,
                                                viewController: self,
                                                navigationController: navigationController,
                                                navigationItem: navigationItem
                )
                trackersView.viewController = self
                self.view = trackersView
        
        let storage = TrackerStorage.shared
        categories = storage.loadCategories()
        categories.forEach {
            if $0.trackers.count != 0 { visibleCategories.append($0) }
        }
        
        //Make Trackers on View
        trackersView.setTrackersCollection(isEmpty: categories.isEmpty)
    }
    
    func presentNewTrackerViewController() {
        let newTrackerViewController = ChoiceViewController()
        newTrackerViewController.modalPresentationStyle = .popover
        self.present(newTrackerViewController, animated: true)
    }
}
