import UIKit

final class CategoriesView: UIView, CategoriesViewProtocol {
    var viewController: CategoriesViewControllerProtocol?
    
// MARK: - Create elements
    private lazy var categoriesTable: UITableView = {
        let categoriesTable = UITableView()
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        categoriesTable.layer.cornerRadius = 16
        categoriesTable.layer.masksToBounds = true
        categoriesTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        categoriesTable.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        categoriesTable.allowsMultipleSelection = false
        categoriesTable.dataSource = viewController
        categoriesTable.delegate = viewController
        return categoriesTable
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton()
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.layer.masksToBounds = true
        addCategoryButton.backgroundColor = .ypBlack
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(.ypWhite, for: .normal)
        addCategoryButton.titleLabel?.font = .systemFont(ofSize: 16)
        return addCategoryButton
    }()
    
// MARK: -
    init(frame: CGRect, viewController: CategoriesViewControllerProtocol) {
        super.init(frame: frame)
        self.viewController = viewController
                
        self.backgroundColor = .ypWhite
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Add elements
    func addSubviews() {
        addSubview(addCategoryButton)
        NSLayoutConstraint.activate([
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
        
        addSubview(categoriesTable)
        let rowsCount = CGFloat(viewController?.viewModel?.categories.count ?? 0)
        let rowsHeight = categoriesTable.heightAnchor.constraint(equalToConstant: rowsCount * 75)
        rowsHeight.priority = UILayoutPriority(rawValue: 999)
        rowsHeight.isActive = true
        NSLayoutConstraint.activate([
            categoriesTable.topAnchor.constraint(equalTo: topAnchor, constant: 87),
            rowsHeight,
            categoriesTable.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor, constant: -24),
            categoriesTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoriesTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
//MARK: - Functions
    @objc
    func didTapAddCategoryButton(){
        viewController?.didTapAddCategoryButton()
    }
}

