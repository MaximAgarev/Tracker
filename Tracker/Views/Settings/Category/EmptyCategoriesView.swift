import UIKit

protocol CategoriesViewProtocol: AnyObject {
    var viewController: CategoriesViewControllerProtocol? { get set }
}

final class EmptyCategoriesView: UIView, CategoriesViewProtocol {
    var viewController: CategoriesViewControllerProtocol?
    
// MARK: - Create elements
    private lazy var emptyImage: UIImageView = {
        let emptyImage = UIImage(named: "Empty Trackers Tab Image")
        let emptyImageView = UIImageView(image: emptyImage)
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        return emptyImageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "Привычки и события можно объединить по смыслу"
        emptyLabel.font = .systemFont(ofSize: 12)
        return emptyLabel
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
        addSubview(emptyImage)
        NSLayoutConstraint.activate([
            emptyImage.topAnchor.constraint(equalTo: topAnchor, constant: 295),
            emptyImage.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        
        addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(addCategoryButton)
        NSLayoutConstraint.activate([
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            ])
    }
    
//MARK: - Functions
    @objc
    func didTapAddCategoryButton(){
        viewController?.didTapAddCategoryButton()
    }
}
