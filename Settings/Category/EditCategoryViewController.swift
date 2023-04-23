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
    
    private lazy var categoryNameLabel: TextField = {
        let categoryNameLabel = TextField()
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.backgroundColor = .ypBackground
        categoryNameLabel.layer.cornerRadius = 16
        categoryNameLabel.layer.masksToBounds = true
        categoryNameLabel.placeholder = "Введите название трекера"
        categoryNameLabel.clearButtonMode = .whileEditing
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
        if !isNew { categoryNameLabel.text = editTitle }
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
        
        view.addSubview(categoryNameLabel)
        NSLayoutConstraint.activate([
            categoryNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            categoryNameLabel.heightAnchor.constraint(equalToConstant: 75),
            categoryNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
        let storage = TrackerStorage.shared
        var storedCategories = storage.loadCategories()
        guard let title = categoryNameLabel.text else { return }
        for category in storedCategories {
            if category.title == title { return }
        }
        let categoryToAdd: TrackerCategory = TrackerCategory(title: title, trackers: [])
        storedCategories.append(categoryToAdd)
        storage.saveCategories(categories: storedCategories)
        dismiss(animated: true)
    }
}

