import UIKit

protocol ScheduleViewControllerProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var scheduleView: ScheduleViewProtocol? { get set }
    var delegate: NewTrackerViewController? { get set }
    
    func didTapAddScheduleButton()
}

final class ScheduleViewController: UIViewController, ScheduleViewControllerProtocol {
    var scheduleView: ScheduleViewProtocol?
    var delegate: NewTrackerViewController?
    
    var chosenDays: [String] = []
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Расписание"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.textColor = .ypBlack
        return headerLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scheduleView = ScheduleView(frame: .zero, viewController: self)
        self.view = scheduleView
        
        addHeaderLabel()
    }
    
    func addHeaderLabel() {
        view.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func didTapAddScheduleButton() {
        var schedule = chosenDays.joined(separator: ", ")
        if chosenDays.count == 7 { schedule = Weekday.week }
        delegate?.newTrackerView?.updateCategoryCell(value: schedule, isCategory: false)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath as IndexPath) as? CategoryCell else { return CategoryCell() }
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        cell.backgroundColor = .ypBackground
        cell.titleLabel.text = Weekday.longName[indexPath.row]//weekdays[indexPath.row]
        addSwitch(cell: cell, identifier: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func addSwitch(cell: CategoryCell, identifier: Int) {
        let choiceSwitch = UISwitch()
        cell.contentView.addSubview(choiceSwitch)
        
        choiceSwitch.accessibilityIdentifier = String(identifier)
            
            choiceSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            choiceSwitch.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                choiceSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                choiceSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
            ])
        }
    
    @objc
    func switchValueDidChange(_ sender: UISwitch) {
        guard let index = sender.accessibilityIdentifier,
              let index = Int(index) else { return }
        let day = Weekday.shortName[index]
        if sender.isOn {
            chosenDays.append(day)
        } else {
            guard let index = chosenDays.firstIndex(of: day) else { return }
            chosenDays.remove(at: index)
        }
    }

}
