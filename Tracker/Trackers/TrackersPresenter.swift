import Foundation

protocol TrackersPresenterProtocol {
    var viewController: TrackersViewControllerProtocol? { get set }
    var view: TrackersViewProtocol? { get set }
    
    func viewDidLoad()
}

final class TrackersPresenter: TrackersPresenterProtocol {
    weak var viewController: TrackersViewControllerProtocol?
    weak var view: TrackersViewProtocol?
    
    func viewDidLoad() {
        guard let viewController = viewController else { return }
        view?.setTrackersCollection(isEmpty: viewController.categories.isEmpty)
    }
    
    
}
