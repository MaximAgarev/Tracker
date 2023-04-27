import UIKit

protocol ScheduleViewControllerProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var scheduleView: ScheduleViewProtocol? { get set }
    var delegate: NewTrackerViewController? { get set }
    var selectedSchedule: String? { get set }
    
    func didTapAddScheduleButton()
}

final class ScheduleViewController: UIViewController, ScheduleViewControllerProtocol {
    var scheduleView: ScheduleViewProtocol?
    var delegate: NewTrackerViewController?
    var selectedSchedule: String?
    
    var chosenDays: [String] = []
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Расписание"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.textColor = .ypBlack
        return headerLabel
    }()
    
    private var choiceSwitches: [UISwitch] = []
    
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
        choiceSwitches.forEach {
            if $0.isOn {
                let index = choiceSwitches.firstIndex(of: $0) ?? 0
                chosenDays.append(Weekday.shortName[index])
            }
        }
        var scheduleSet: String? = chosenDays.joined(separator: ", ")
        if chosenDays.count == 7 { scheduleSet = Weekday.everyDay }
        if chosenDays.isEmpty { scheduleSet = nil }
        delegate?.newTrackerView?.updateCategoryCell(value: scheduleSet, isCategory: false)
        guard let schedule = scheduleSet else { return }
        delegate?.tracker.schedule = schedule
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
        cell.titleLabel.text = Weekday.longName[indexPath.row]
        let isOn = selectedSchedule?.range(of: Weekday.shortName[indexPath.row]) != nil
        addSwitch(cell: cell, identifier: indexPath.row, isOn: isOn)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func addSwitch(cell: CategoryCell, identifier: Int, isOn: Bool) {
        let choiceSwitch = UISwitch()
        cell.contentView.addSubview(choiceSwitch)
        choiceSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        choiceSwitch.accessibilityIdentifier = String(identifier)
        choiceSwitch.isOn = isOn
        choiceSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            choiceSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            choiceSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
        ])
        
        choiceSwitches.append(choiceSwitch)
    }
    
    @objc
    func switchValueDidChange(_ sender: UISwitch) {
        guard let index = sender.accessibilityIdentifier,
              let index = Int(index) else { return }
        choiceSwitches[index].isOn = sender.isOn
    }

}
