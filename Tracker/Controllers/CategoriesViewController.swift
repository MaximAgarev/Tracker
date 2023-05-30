import UIKit

protocol CategoriesViewControllerProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var delegate: NewTrackerViewController? { get set }
    var viewModel: CategoriesViewModel? { get set }
    var selectedCategory: String? { get set }
    
    func setView()
    func didTapAddCategoryButton()
}

final class CategoriesViewController: UIViewController, CategoriesViewControllerProtocol {
    weak var delegate: NewTrackerViewController?
    
    var viewModel: CategoriesViewModel?
    
    var selectedCategory: String?
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Категория"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.textColor = .ypBlack
        return headerLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CategoriesViewModel()
        viewModel?.onChange = setView

        setView()
    }
    
    func setView() {
        guard let viewModel = viewModel else { return }
        if viewModel.categories.count == 0 {
            self.view = EmptyCategoriesView(frame: .zero, viewController: self)
        } else {
            self.view = CategoriesView(frame: .zero, viewController: self)
        }
    }

    private func addHeaderLabel() {
        view.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func didTapAddCategoryButton() {
        guard let viewModel = viewModel else { return }
        presentEditCategoryViewController(
            viewModel: viewModel,
            isNew: true,
            editTitle: nil
        )
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath as IndexPath)
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        cell.textLabel?.text = viewModel?.categories[indexPath.row]
        cell.accessoryType = cell.textLabel?.text == selectedCategory ? .checkmark : .none
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
        let value = cell?.textLabel?.text ?? ""
        delegate?.newTrackerView?.updateCategoryCell(value: value, isCategory: true)
        delegate?.category = value
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let viewModel = viewModel else { return nil }
        return UIContextMenuConfiguration(actionProvider:  { actions in
            let cell = tableView.cellForRow(at: indexPath)
            let title = cell?.textLabel?.text
            return UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.presentEditCategoryViewController(
                        viewModel: viewModel,
                        isNew: false,
                        editTitle: title
                    )
                },
                UIAction(title: "Удалить", attributes: .destructive, handler: { [weak self] _ in
                    let alert = UIAlertController(
                        title: nil,
                        message: "Эта категория точно не нужна?",
                        preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "Удалить", style: .destructive) {_ in
                        viewModel.deleteCategory(categoryTitle: title ?? "")
                        self?.delegate?.newTrackerView?.updateCategoryCell(value: nil, isCategory: true)
                        self?.setView()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTrackers"), object: nil)
                    }
                    let cancel = UIAlertAction(title: "Отмена", style: .cancel)
                    alert.addAction(action)
                    alert.addAction(cancel)
                    self?.present(alert, animated: true)
                }),
            ])
        })
    }
    
    func presentEditCategoryViewController(viewModel: CategoriesViewModel, isNew: Bool, editTitle: String?) {
        let editCategoryViewController = EditCategoryViewController()
        editCategoryViewController.viewModel = viewModel
        editCategoryViewController.isNew = isNew
        editCategoryViewController.editTitle = editTitle
        editCategoryViewController.delegate = self
        editCategoryViewController.modalPresentationStyle = .popover
        self.present(editCategoryViewController, animated: true)
    }
}
