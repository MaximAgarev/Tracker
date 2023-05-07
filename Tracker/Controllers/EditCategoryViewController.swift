import UIKit

final class EditCategoryViewController: UIViewController {
    
    var delegate: CategoriesViewControllerProtocol?
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
        let storage = TrackerStorageCoreData.shared
        var storedCategories = storage.loadCategories()
        guard let title = categoryNameTextField.text,
              title != "" else { return }
        for category in storedCategories {
            if category.title == title { return }
        }
        if isNew {
            storedCategories.append(TrackerCategory(title: title, trackers: []))
        } else {
            guard let index = storedCategories.firstIndex(where: { $0.title == editTitle }) else { return }
            storedCategories[index].title = title
        }
        storage.saveCategories(categories: storedCategories)
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
