import UIKit

protocol NewTrackerViewProtocol: AnyObject {
    var viewController: NewTrackerViewControllerProtocol? { get set }
}

final class NewTrackerView: UIView, NewTrackerViewProtocol {
    weak var viewController: NewTrackerViewControllerProtocol?
    
    
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        guard let viewController = viewController else { return UILabel() }
        headerLabel.text = viewController.isHabit ? "Новая привычка" : "Новое нерегулярное событие"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.textColor = .ypBlack
        return headerLabel
    }()
    
    private lazy var trackerNameLabel: UITextField = {
        let trackerNameLabel = TextField() //UITextField()
        trackerNameLabel.backgroundColor = .ypBackground
        trackerNameLabel.layer.cornerRadius = 16
        trackerNameLabel.layer.masksToBounds = true
        trackerNameLabel.placeholder = "Введите название трекера"
        return trackerNameLabel
    }()
    
    private lazy var trackerCategoryTable: UITableView = {
        let trackerCategoryTable = UITableView()
        trackerCategoryTable.layer.cornerRadius = 16
        trackerCategoryTable.layer.masksToBounds = true
        trackerCategoryTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        trackerCategoryTable.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        trackerCategoryTable.dataSource = viewController
        trackerCategoryTable.delegate = viewController
        return trackerCategoryTable
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.text = "Emoji"
        emojiLabel.font = .boldSystemFont(ofSize: 19)
        emojiLabel.textColor = .ypBlack
        return emojiLabel
    }()
    
    private lazy var emojiCollection: UICollectionView = {
        let emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollection.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        emojiCollection.dataSource = viewController
        emojiCollection.delegate = viewController
        return emojiCollection
    }()
        
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = .ypGray
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16)
        return createButton
    }()
        
    init(frame: CGRect, viewController: NewTrackerViewControllerProtocol) {
        super.init(frame: frame)
        self.viewController = viewController
        
        self.backgroundColor = .ypWhite
        
        addHeaderLabel()
        addTrackerNameLabel()
        addTrackerCategoryTable()
        addEmojiLabel()
        addEmojiCollection()
        addCreateButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addHeaderLabel() {
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func addTrackerNameLabel() {
        addSubview(trackerNameLabel)
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackerNameLabel.heightAnchor.constraint(equalToConstant: 60),
            trackerNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 87),
            trackerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    func addTrackerCategoryTable() {
        addSubview(trackerCategoryTable)
        trackerCategoryTable.translatesAutoresizingMaskIntoConstraints = false
        guard let viewController = viewController else { return }
        NSLayoutConstraint.activate([
            trackerCategoryTable.widthAnchor.constraint(equalTo:widthAnchor, constant: -40),
            trackerCategoryTable.heightAnchor.constraint(equalToConstant: viewController.isHabit ? 150 : 75),
            trackerCategoryTable.topAnchor.constraint(equalTo: trackerNameLabel.bottomAnchor, constant: 24),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    func addEmojiLabel() {
        addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            emojiLabel.topAnchor.constraint(equalTo: trackerCategoryTable.bottomAnchor, constant: 32)
            ])
    }
    
    func addEmojiCollection() {
        addSubview(emojiCollection)
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 1),
            emojiCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
    
    func addCreateButton() {
            createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
            addSubview(createButton)
            createButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                createButton.heightAnchor.constraint(equalToConstant: 60),
                createButton.topAnchor.constraint(equalTo: topAnchor, constant: 844),
                createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
                ])
        }

    @objc
    func didTapCreateButton(){
        viewController?.didTapCreateButton()
    }
}
