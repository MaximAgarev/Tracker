import UIKit

protocol CategoriesViewControllerProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var categoriesView: CategoriesViewProtocol? { get set }
    var delegate: NewTrackerViewController? { get set }
    
    func didTapAddCategoryButton()
}

final class CategoriesViewController: UIViewController, CategoriesViewControllerProtocol {
    
    var categoriesView: CategoriesViewProtocol?
    var delegate: NewTrackerViewController?
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Категория"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.textColor = .ypBlack
        return headerLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let categoriesView = EmptyView(frame: .zero, viewController: self)
        let categoriesView = CategoriesView(frame: .zero, viewController: self)
        self.view = categoriesView
        
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
    
    func didTapAddCategoryButton() {
        print("Tap!")
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath as IndexPath)
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        cell.textLabel?.text = "Test"
        cell.accessoryType = .none
        cell.backgroundColor = .ypBackground
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        delegate?.newTrackerView?.updateCategoryCell(value: cell?.textLabel?.text ?? "", isCategory: true)
        dismiss(animated: true)
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(actionProvider:  { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    print(indexPath)
                },
                UIAction(title: "Удалить", attributes: .destructive, handler: { [weak self] _ in
                    print(indexPath)
                }),
            ])
        })
    }
}
