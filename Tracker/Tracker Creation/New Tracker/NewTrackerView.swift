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
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24
        view.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let redView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        view.backgroundColor = .red
        return view
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
        emojiCollection.tag = 1
        emojiCollection.dataSource = viewController
        emojiCollection.delegate = viewController
        return emojiCollection
    }()
    
    private lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = "Цвет"
        colorLabel.font = .boldSystemFont(ofSize: 19)
        colorLabel.textColor = .ypBlack
        return colorLabel
    }()
    
    private lazy var colorCollection: UICollectionView = {
        let colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorCollection.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        colorCollection.dataSource = viewController
        colorCollection.delegate = viewController
        return colorCollection
    }()
    
    private lazy var cancelButton: UIButton = {
        let createButton = UIButton()
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = .ypGray
        createButton.setTitle("Отменить", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16)
        return createButton
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
        
        addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 63).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollViewContainer.backgroundColor = .brown
        addHeaderLabel()
        addTrackerNameLabel()
        addTrackerCategoryTable()
        addEmojiLabel()
        addEmojiCollection()
        addColorLabel()
        addColorCollection()
        scrollViewContainer.addArrangedSubview(redView)
//        addCreateButton()
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
        scrollViewContainer.addArrangedSubview(trackerNameLabel)
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackerNameLabel.heightAnchor.constraint(equalToConstant: 60),
//            trackerNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 87),
            trackerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }

    func addTrackerCategoryTable() {
        scrollViewContainer.addArrangedSubview(trackerCategoryTable)
        trackerCategoryTable.translatesAutoresizingMaskIntoConstraints = false
        guard let viewController = viewController else { return }
        NSLayoutConstraint.activate([
            trackerCategoryTable.widthAnchor.constraint(equalTo:widthAnchor, constant: -40),
            trackerCategoryTable.heightAnchor.constraint(equalToConstant: viewController.isHabit ? 150 : 75),
//            trackerCategoryTable.topAnchor.constraint(equalTo: trackerNameLabel.bottomAnchor, constant: 24),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }

    func addEmojiLabel() {
        scrollViewContainer.addArrangedSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            ])
    }

    func addEmojiCollection() {
        scrollViewContainer.addArrangedSubview(emojiCollection)
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
    
    func addColorLabel() {
        scrollViewContainer.addArrangedSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            ])
    }
    
    func addColorCollection() {
        scrollViewContainer.addArrangedSubview(colorCollection)
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorCollection.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }

//    func addCreateButton() {
//        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
//        contentView.addSubview(createButton)
//            createButton.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                createButton.heightAnchor.constraint(equalToConstant: 60),
//                createButton.topAnchor.constraint(equalTo: bottomAnchor),
//                createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//                createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
//                ])
//        }

    @objc
    func didTapCreateButton(){
        viewController?.didTapCreateButton()
    }
}
