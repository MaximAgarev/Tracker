import UIKit

protocol NewTrackerViewProtocol: AnyObject {
    var viewController: NewTrackerViewControllerProtocol? { get set }
}

final class NewTrackerView: UIView, NewTrackerViewProtocol {
    weak var viewController: NewTrackerViewControllerProtocol?
    
// MARK: - Create elements
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        guard let viewController = viewController else { return UILabel() }
        headerLabel.text = viewController.isHabit ? "Новая привычка" : "Новое нерегулярное событие"
        headerLabel.font = .systemFont(ofSize: 16)
        headerLabel.textColor = .ypBlack
        return headerLabel
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var scrollViewStack: UIStackView = {
        let scrollViewStack = UIStackView()
        scrollViewStack.axis = .vertical
        scrollViewStack.spacing = 24
        scrollViewStack.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        scrollViewStack.isLayoutMarginsRelativeArrangement = true
        scrollViewStack.translatesAutoresizingMaskIntoConstraints = false
        return scrollViewStack
    }()
    
    private lazy var trackerNameLabel: UITextField = {
        let trackerNameLabel = TextField() //UITextField()
        trackerNameLabel.backgroundColor = .ypBackground
        trackerNameLabel.layer.cornerRadius = 16
        trackerNameLabel.layer.masksToBounds = true
        trackerNameLabel.placeholder = "Введите название трекера"
        return trackerNameLabel
    }()
    
    private lazy var longNameWarning: UILabel = {
        let longNameWarning = UILabel()
        longNameWarning.text = "Ограничение 38 символов"
        longNameWarning.textColor = .ypRed
        longNameWarning.font = .systemFont(ofSize: 17)
        longNameWarning.textAlignment = .center
        return longNameWarning
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
    
    let buttonsStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.backgroundColor = .ypWhite
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = CGColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
        return cancelButton
    }()

    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = .ypGray
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16)
        return createButton
    }()
       
// MARK: -
    init(frame: CGRect, viewController: NewTrackerViewControllerProtocol) {
        super.init(frame: frame)
        self.viewController = viewController
        
        self.backgroundColor = .ypWhite
        
        addHeaderLabel()
        addStack()
        addTrackerNameLabel()
        addLongNameWarning()
        addTrackerCategoryTable()
        addEmojiLabel()
        addEmojiCollection()
        addColorLabel()
        addColorCollection()
        addButtonsStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Add elements
    func addHeaderLabel() {
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func addStack() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 63),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        scrollView.addSubview(scrollViewStack)
        NSLayoutConstraint.activate([
            scrollViewStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func addTrackerNameLabel() {
        scrollViewStack.addArrangedSubview(trackerNameLabel)
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackerNameLabel.heightAnchor.constraint(equalToConstant: 60),
            trackerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    func addLongNameWarning() {
        scrollViewStack.addArrangedSubview(longNameWarning)
        NSLayoutConstraint.activate([
            longNameWarning.topAnchor.constraint(equalTo: trackerNameLabel.bottomAnchor, constant: 8),
            longNameWarning.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        longNameWarning.isHidden = true
    }

    func addTrackerCategoryTable() {
        scrollViewStack.addArrangedSubview(trackerCategoryTable)
        trackerCategoryTable.translatesAutoresizingMaskIntoConstraints = false
        guard let viewController = viewController else { return }
        NSLayoutConstraint.activate([
            trackerCategoryTable.widthAnchor.constraint(equalTo:widthAnchor, constant: -40),
            trackerCategoryTable.heightAnchor.constraint(equalToConstant: viewController.isHabit ? 150 : 75),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }

    func addEmojiLabel() {
        scrollViewStack.addArrangedSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            ])
    }

    func addEmojiCollection() {
        scrollViewStack.addArrangedSubview(emojiCollection)
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
    
    func addColorLabel() {
        scrollViewStack.addArrangedSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            colorLabel.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 16)
            ])
    }
    
    func addColorCollection() {
        scrollViewStack.addArrangedSubview(colorCollection)
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorCollection.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
    
    func addButtonsStack() {
        scrollViewStack.addArrangedSubview(buttonsStack)
        buttonsStack.distribution = .fillEqually
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStack.topAnchor.constraint(equalTo: colorCollection.bottomAnchor, constant: 16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(createButton)
    }

    @objc
    func didTapCreateButton(){
        longNameWarning.isHidden.toggle()
        viewController?.didTapCreateButton()
    }
    
    @objc
    func didTapCancelButton(){
        viewController?.didTapCancelButton()
    }
}
