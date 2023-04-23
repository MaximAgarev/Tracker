import UIKit

protocol ScheduleViewProtocol: AnyObject {
    var viewController: ScheduleViewControllerProtocol? { get set }
}

final class ScheduleView: UIView, ScheduleViewProtocol {
    var viewController: ScheduleViewControllerProtocol?
    
    private lazy var scheduleTable: UITableView = {
        let scheduleTable = UITableView()
        scheduleTable.translatesAutoresizingMaskIntoConstraints = false
        scheduleTable.layer.cornerRadius = 16
        scheduleTable.layer.masksToBounds = true
        scheduleTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        scheduleTable.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        scheduleTable.isScrollEnabled = false
        scheduleTable.allowsSelection = false
        scheduleTable.dataSource = viewController
        scheduleTable.delegate = viewController
        return scheduleTable
    }()
    
    private lazy var addScheduleButton: UIButton = {
        let addScheduleButton = UIButton()
        addScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        addScheduleButton.addTarget(self, action: #selector(didTapAddScheduleButton), for: .touchUpInside)
        addScheduleButton.layer.cornerRadius = 16
        addScheduleButton.layer.masksToBounds = true
        addScheduleButton.backgroundColor = .ypBlack
        addScheduleButton.setTitle("Готово", for: .normal)
        addScheduleButton.setTitleColor(.ypWhite, for: .normal)
        addScheduleButton.titleLabel?.font = .systemFont(ofSize: 16)
        return addScheduleButton
    }()
    
    init(frame: CGRect, viewController: ScheduleViewControllerProtocol) {
        super.init(frame: frame)
        self.viewController = viewController
        
        self.backgroundColor = .ypWhite
        
        addSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        
        addSubview(addScheduleButton)
        NSLayoutConstraint.activate([
            addScheduleButton.heightAnchor.constraint(equalToConstant: 60),
            addScheduleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addScheduleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addScheduleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            ])
        
        addSubview(scheduleTable)
        NSLayoutConstraint.activate([
            scheduleTable.topAnchor.constraint(equalTo: topAnchor, constant: 87),
            scheduleTable.heightAnchor.constraint(equalToConstant: 7 * 75),
            scheduleTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scheduleTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        
    }
    
    @objc
    func didTapAddScheduleButton(){
        viewController?.didTapAddScheduleButton()
    }
}
