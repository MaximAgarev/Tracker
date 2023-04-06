import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var trackersView: TrackersViewProtocol? { get set }
    var trackersPresenter: TrackersPresenterProtocol? { get set }
    
    var categories: [TrackerCategory] { get set }
    var visibleCategories: [TrackerCategory] { get set }
}

class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    var trackersView: TrackersViewProtocol?
    var trackersPresenter: TrackersPresenterProtocol?
    
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
#warning ("Remove dummy for prod")
        let tracker1 = Tracker(id: 1, title: "Кошка заслонила камеру на созвоне", color: .magenta, emoji: "🙂", schedule: nil)
        let tracker2 = Tracker(id: 1, title: "Свидания в апреле", color: .green, emoji: "🌺", schedule: nil)
        let trackerCategory1 = TrackerCategory(title: "Радостные мелочи", trackers: [tracker1, tracker2])
        categories.append(trackerCategory1)
        
        let tracker3 = Tracker(id: 1, title: "Бабушка прислала открытку в вотсапе", color: .brown, emoji: "🥦", schedule: nil)
        let tracker4 = Tracker(id: 1, title: "Хорошее настроение", color: .purple, emoji: "🥶", schedule: nil)
        let trackerCategory2 = TrackerCategory(title: "Самочувствие", trackers: [tracker3, tracker4])
        categories.append(trackerCategory2)
        
        guard let navigationController = navigationController else { return }
        let trackersView = TrackersView(frame: .zero,
                                        viewController: self,
                                        navigationController: navigationController,
                                        navigationItem: navigationItem
        )
        trackersView.viewController = self
        self.view = trackersView
        
        trackersPresenter = TrackersPresenter()
        trackersPresenter?.viewController = self
        trackersPresenter?.view = trackersView
        
        trackersPresenter?.viewDidLoad()
    }
}
