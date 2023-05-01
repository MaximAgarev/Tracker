import UIKit

protocol NewTrackerViewProtocol: AnyObject {
    var viewController: NewTrackerViewControllerProtocol? { get set }
    
    func updateCategoryCell(value: String?, isCategory: Bool)
    func createButtonAvailability(element: String, state: Bool)
}

final class NewTrackerView: UIView, NewTrackerViewProtocol {
    weak var viewController: NewTrackerViewControllerProtocol?
    
    var spaceForErrorLabelConstraint: NSLayoutConstraint!
    
// MARK: - Create elements
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var trackerNameLabel: TextField = {
        let trackerNameLabel = TextField()
        trackerNameLabel.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLabel.backgroundColor = .ypBackground
        trackerNameLabel.layer.cornerRadius = 16
        trackerNameLabel.layer.masksToBounds = true
        trackerNameLabel.placeholder = "Введите название трекера"
        trackerNameLabel.clearButtonMode = .whileEditing
        trackerNameLabel.delegate = self
        return trackerNameLabel
    }()
    
    private lazy var longNameWarning: UILabel = {
        let longNameWarning = UILabel()
        longNameWarning.translatesAutoresizingMaskIntoConstraints = false
        longNameWarning.text = "Ограничение 38 символов"
        longNameWarning.textColor = .ypRed
        longNameWarning.font = .systemFont(ofSize: 17)
        longNameWarning.textAlignment = .center
        return longNameWarning
    }()

    private lazy var trackerCategoryTable: UITableView = {
        let trackerCategoryTable = UITableView()
        trackerCategoryTable.translatesAutoresizingMaskIntoConstraints = false
        trackerCategoryTable.layer.cornerRadius = 16
        trackerCategoryTable.layer.masksToBounds = true
        trackerCategoryTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        trackerCategoryTable.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        trackerCategoryTable.dataSource = viewController
        trackerCategoryTable.delegate = viewController
        return trackerCategoryTable
    }()

    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = "Emoji"
        emojiLabel.font = .boldSystemFont(ofSize: 19)
        emojiLabel.textColor = .ypBlack
        return emojiLabel
    }()

    private lazy var emojiCollection: UICollectionView = {
        let emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        emojiCollection.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        emojiCollection.allowsMultipleSelection = false
        emojiCollection.tag = 1
        emojiCollection.dataSource = viewController
        emojiCollection.delegate = viewController
        return emojiCollection
    }()
    
    private lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.text = "Цвет"
        colorLabel.font = .boldSystemFont(ofSize: 19)
        colorLabel.textColor = .ypBlack
        return colorLabel
    }()
    
    private lazy var colorCollection: UICollectionView = {
        let colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        colorCollection.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        colorCollection.allowsMultipleSelection = false
        colorCollection.dataSource = viewController
        colorCollection.delegate = viewController
        return colorCollection
    }()
    
    let buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        buttonsStack.isLayoutMarginsRelativeArrangement = true
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStack
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
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

    private lazy var createButton: CreateTrackerButton = {
        let createButton = CreateTrackerButton()
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = .ypGray
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16)
        createButton.isEnabled = false
        return createButton
    }()
       
// MARK: -
    init(frame: CGRect, viewController: NewTrackerViewControllerProtocol) {
        super.init(frame: frame)
        self.viewController = viewController
        
        self.backgroundColor = .ypWhite
        
        addHeaderLabel()
        addScrollContentView()
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
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func addScrollContentView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 63),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
    }
    
    func addTrackerNameLabel() {
        contentView.addSubview(trackerNameLabel)
        NSLayoutConstraint.activate([
            trackerNameLabel.heightAnchor.constraint(equalToConstant: 75),
            trackerNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            trackerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
    
    func addLongNameWarning() {
        contentView.addSubview(longNameWarning)
        NSLayoutConstraint.activate([
            longNameWarning.topAnchor.constraint(equalTo: trackerNameLabel.bottomAnchor, constant: 8),
            longNameWarning.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        longNameWarning.isHidden = true
    }

    func addTrackerCategoryTable() {
        contentView.addSubview(trackerCategoryTable)
        spaceForErrorLabelConstraint = trackerCategoryTable.topAnchor.constraint(equalTo: trackerNameLabel.bottomAnchor, constant: 24)
        guard let viewController = viewController else { return }
        NSLayoutConstraint.activate([
            spaceForErrorLabelConstraint,
            trackerCategoryTable.widthAnchor.constraint(equalTo:widthAnchor, constant: -40),
            trackerCategoryTable.heightAnchor.constraint(equalToConstant: viewController.isHabit ? 150 : 75),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }

    func addEmojiLabel() {
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: trackerCategoryTable.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
            ])
    }

    func addEmojiCollection() {
        contentView.addSubview(emojiCollection)
        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
    
    func addColorLabel() {
        contentView.addSubview(colorLabel)
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            colorLabel.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 16)
            ])
    }
    
    func addColorCollection() {
        contentView.addSubview(colorCollection)
        colorCollection.allowsMultipleSelection = false
        NSLayoutConstraint.deactivate(colorCollection.constraints)
        NSLayoutConstraint.activate([
            colorCollection.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
    
    func addButtonsStack() {
        contentView.addSubview(buttonsStack)
        buttonsStack.distribution = .fillEqually
        NSLayoutConstraint.deactivate(buttonsStack.constraints)
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStack.topAnchor.constraint(equalTo: colorCollection.bottomAnchor, constant: 16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(createButton)
        createButton.scheduleSelected = !(viewController?.isHabit ?? false)
        
        contentView.bottomAnchor.constraint(equalTo: buttonsStack.bottomAnchor).isActive = true
    }
    
//MARK: - Functions
    @objc
    func didTapCreateButton(){
        viewController?.didTapCreateButton()
    }
    
    @objc
    func didTapCancelButton(){
        viewController?.didTapCancelButton()
    }
    
    func updateCategoryCell(value: String?, isCategory: Bool){
        let indexPath: IndexPath = isCategory ? [0,0] : [0, 1]
        let element = isCategory ? "category" : "schedule"
        let cell = trackerCategoryTable.cellForRow(at: indexPath) as? CategoryCell
        
        if value != nil {
            cell?.valueLabel.text = value
            cell?.configureTableForTwoRows()
            createButtonAvailability(element: element, state: true)
        } else {
            cell?.configureTableForOneRow()
            createButtonAvailability(element: element, state: false)
        }
    }
    
    func createButtonAvailability(element: String, state: Bool) {
        switch element {
        case "title":
            createButton.titleEntered = state
        case "category":
            createButton.categorySelected = state
        case "schedule":
            createButton.scheduleSelected = state
        case "emoji":
            createButton.emojiSelected = state
        case "color":
            createButton.colorSelected = state
        default:
            return
        }
    }
}

//MARK: - Extensions
extension NewTrackerView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if count < 38 {
            longNameWarning.isHidden = true
            spaceForErrorLabelConstraint.constant = 24
        } else {
            longNameWarning.isHidden = false
            spaceForErrorLabelConstraint.constant = 62
        }
        return count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerNameLabel.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        longNameWarning.isHidden = true
        spaceForErrorLabelConstraint.constant = 24
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewController?.trackerParams.title = trackerNameLabel.text ?? ""
        createButtonAvailability(element: "title", state: !(trackerNameLabel.text?.isEmpty ?? true))
    }
}
