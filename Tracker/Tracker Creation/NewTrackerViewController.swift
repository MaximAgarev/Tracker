import UIKit

protocol NewTrackerViewControllerProtocol: AnyObject {
    var newTrackerView: NewTrackerViewProtocol? { get set }
    func didTapHabitButton()
    func didTapEventButton()
}

final class NewTrackerViewController: UIViewController, NewTrackerViewControllerProtocol {
    var newTrackerView: NewTrackerViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newTrackerView = NewTrackerView(frame: .zero, viewController: self)
        self.view = newTrackerView
    }
    
    func didTapHabitButton(){
        print("Habit!")
    }
    
    func didTapEventButton(){
        print("Event!")
    }
}
