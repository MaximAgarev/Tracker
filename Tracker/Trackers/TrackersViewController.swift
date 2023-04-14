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
        
        
        #warning ("Remove for prod")
        makeDummy()
        
        //Make Trackers on View
        trackersView.setTrackersCollection(isEmpty: categories.isEmpty)
    }
    
    func presentNewTrackerViewController() {
        let newTrackerViewController = ChoiceViewController()
        newTrackerViewController.modalPresentationStyle = .popover
        self.present(newTrackerViewController, animated: true)
    }
    
    //Dummy for development
    func makeDummy() {
                let tracker1 = Tracker(id: 1, title: "Кошка заслонила камеру на созвоне", color: .ypColorSelection[1], emoji: "🙂", schedule: nil)
                let tracker2 = Tracker(id: 1, title: "Свидания в апреле", color: .ypColorSelection[2], emoji: "🌺", schedule: nil)
                let trackerCategory1 = TrackerCategory(title: "Радостные мелочи", trackers: [tracker1, tracker2])
                categories.append(trackerCategory1)
                
                let tracker3 = Tracker(id: 1, title: "Бабушка прислала открытку в вотсапе", color: .ypColorSelection[3], emoji: "🥦", schedule: nil)
                let tracker4 = Tracker(id: 1, title: "Хорошее настроение", color: .ypColorSelection[4], emoji: "🥶", schedule: nil)
                let trackerCategory2 = TrackerCategory(title: "Самочувствие", trackers: [tracker3, tracker4])
                categories.append(trackerCategory2)
    }
}
