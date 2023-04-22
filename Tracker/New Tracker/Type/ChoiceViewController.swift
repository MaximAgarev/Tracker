import UIKit

protocol ChoiceViewControllerProtocol: AnyObject {
    var choiceView: ChoiceViewProtocol? { get set }
    func presentNewTrackerViewController(isHabit: Bool)
    func didTapEventButton()
}

final class ChoiceViewController: UIViewController, ChoiceViewControllerProtocol {
    var choiceView: ChoiceViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let choiceView = ChoiceView(frame: .zero, viewController: self)
        self.view = choiceView
    }
    
    func presentNewTrackerViewController(isHabit: Bool) {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.isHabit = isHabit
        newTrackerViewController.modalPresentationStyle = .popover
        self.present(newTrackerViewController, animated: true)
    }
    
    func didTapEventButton(){
        print("Event!")
    }
}
