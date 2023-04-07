import UIKit

protocol NewTrackerViewProtocol: AnyObject {
    var viewController: NewTrackerViewControllerProtocol? { get set }
}

final class NewTrackerView: UIView, NewTrackerViewProtocol {
    weak var viewController: NewTrackerViewControllerProtocol?
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Создание трекера"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.textColor = .ypBlack
        return headerLabel
        
    }()
    
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.layer.cornerRadius = 16
        habitButton.layer.masksToBounds = true
        habitButton.backgroundColor = .ypBlack
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.titleLabel?.font = .systemFont(ofSize: 16)
        return habitButton
    }()
    
    private lazy var eventButton: UIButton = {
        let eventButton = UIButton()
        eventButton.layer.cornerRadius = 16
        eventButton.layer.masksToBounds = true
        eventButton.backgroundColor = .ypBlack
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.setTitleColor(.ypWhite, for: .normal)
        eventButton.titleLabel?.font = .systemFont(ofSize: 16)
        return eventButton
    }()
        
    init(frame: CGRect, viewController: NewTrackerViewControllerProtocol) {
        super.init(frame: frame)
        self.viewController = viewController
        
        self.backgroundColor = .ypWhite
        
        setHeader()
        setHabitButton()
        setEventButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeader() {
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setHabitButton() {
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        addSubview(habitButton)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.topAnchor.constraint(equalTo: topAnchor, constant: 344),
            habitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    func setEventButton() {
        eventButton.addTarget(self, action: #selector(didTapEventButton), for: .touchUpInside)
        addSubview(eventButton)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.topAnchor.constraint(equalTo: topAnchor, constant: 420),
            eventButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    @objc
    func didTapHabitButton(){
        viewController?.didTapHabitButton()
    }
    
    @objc
    func didTapEventButton(){
        viewController?.didTapEventButton()
    }
    
    
}
