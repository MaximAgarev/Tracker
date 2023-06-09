import UIKit

final class EditCategoryViewController: UIViewController {
    
    weak var delegate: CategoriesViewControllerProtocol?
    var viewModel: CategoriesViewModel?
    var isNew: Bool = true
    var editTitle: String?
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = isNew ? "Новая категория" : "Редактирование категории"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.textColor = .ypBlack
        return headerLabel
    }()
    
    private lazy var categoryNameTextField: TextField = {
        let categoryNameLabel = TextField()
        categoryNameLabel.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.backgroundColor = .ypBackground
        categoryNameLabel.layer.cornerRadius = 16
        categoryNameLabel.layer.masksToBounds = true
        categoryNameLabel.placeholder = "Введите название категории"
        categoryNameLabel.clearButtonMode = .whileEditing
        categoryNameLabel.delegate = self
        return categoryNameLabel
    }()
    
    private lazy var isDoneButton: UIButton = {
        let isDoneButton = UIButton()
        isDoneButton.translatesAutoresizingMaskIntoConstraints = false
        isDoneButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        isDoneButton.layer.cornerRadius = 16
        isDoneButton.layer.masksToBounds = true
        isDoneButton.backgroundColor = .ypBlack
        let buttonText = isNew ? "Добавить категорию" : "Готово"
        isDoneButton.setTitle(buttonText, for: .normal)
        isDoneButton.setTitleColor(.ypWhite, for: .normal)
        isDoneButton.titleLabel?.font = .systemFont(ofSize: 16)
        return isDoneButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        addSubviews()
        if !isNew { categoryNameTextField.text = editTitle }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.setView()
    }
    
    func addSubviews() {
        
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(categoryNameTextField)
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(isDoneButton)
        NSLayoutConstraint.activate([
            isDoneButton.heightAnchor.constraint(equalToConstant: 60),
            isDoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            isDoneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            isDoneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    @objc
    func didTapAddCategoryButton(){
        guard let title = categoryNameTextField.text,
              let viewModel = viewModel,
              title != "",
              !viewModel.checkCategoryExists(title: title) else { return }
        if isNew {
            viewModel.saveCategory(title: title)
        } else {
            if let editTitle = editTitle {
                viewModel.updateCategory(editTitle: editTitle, newTitle: title)
            }
        }
        delegate?.setView()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTrackers"), object: nil)
        dismiss(animated: true)
    }
}

extension EditCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryNameTextField.resignFirstResponder()
        didTapAddCategoryButton()
        return true
    }
}
