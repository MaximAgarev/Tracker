import UIKit

protocol TrackersViewProtocol: AnyObject {
    var viewController: TrackersViewControllerProtocol? { get set }
    
    func setNavigationBar()
    func setTrackersCollection()
}

final class TrackersView: UIView, TrackersViewProtocol {
    
    weak var viewController: TrackersViewControllerProtocol?
    var navigationController: UINavigationController?
    var navigationItem: UINavigationItem?
    
// MARK: - Create elements
    private lazy var emptyImageView: UIImageView = {
        var emptyImage = UIImage(named: "Empty Trackers Tab Image")
        var emptyImageView = UIImageView(image: emptyImage)
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        return emptyImageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let emptyLabel =  UILabel()
        emptyLabel.text = "Что будем отслеживать?"
        emptyLabel.font = .systemFont(ofSize: 12)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        return emptyLabel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackersCell.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.register(TrackersHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryHeader")
        return collectionView
    }()
    
// MARK: -
    init(frame: CGRect, viewController: TrackersViewControllerProtocol, navigationController: UINavigationController, navigationItem: UINavigationItem) {
        super.init(frame: frame)
        self.backgroundColor = .ypWhite
        self.navigationController = navigationController
        self.navigationItem = navigationItem
        
        self.setNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
// MARK: - Add Navigation Bar
    func setNavigationBar() {
        guard let navigationController = navigationController,
              let navigationItem = navigationItem
        else { return }
        let navigationBar = navigationController.navigationBar
        
        // Title
        navigationItem.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        
        // Plus button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Add Tracker NavBar Icon"),
            style: .plain,
            target: self,
            action: #selector(didTapAddTracker))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        // Date picker
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        // Search bar
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    @objc
    func didTapAddTracker() {
        viewController?.presentNewTrackerViewController()
    }
    
    @objc
    func dateChanged(_ sender: UIDatePicker) {
        viewController?.currentDate = sender.date.withoutTime()
        viewController?.setView()
    }
    
// MARK: - Add Trackers Collection
    @objc
    func setTrackersCollection() {
        emptyLabel.removeFromSuperview()
        emptyImageView.removeFromSuperview()
        collectionView.removeFromSuperview()
                
        if viewController?.storage?.numberOfSections == 0 {
            showEmptyTab()
            return
        }
        
        collectionView.reloadData()
        setCollectionView()
    }
    
    func showEmptyTab() {
        if navigationItem?.searchController?.searchBar.text != "" {
            emptyImageView.image = UIImage(named: "Empty Search Image")
            emptyLabel.text = "Ничего не найдено"
        }
        
        addSubview(emptyImageView)
        addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 402),
            emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setCollectionView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//MARK: - Extensions
extension TrackersView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewController?.storage?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.storage?.numberOfRowsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! TrackersCell
        let tracker = viewController?.storage?.getTracker(section: indexPath.section, index: indexPath.row)
        let trackerID = tracker?.id ?? 0
        
#warning("Replace tags with trackerID")
        cell.trackerID = trackerID
        cell.colorCard.backgroundColor = UIColor.ypColorSelection[tracker?.color ?? 0]
        cell.titleLabel.text = tracker?.title
        cell.emodjiLabel.text = tracker?.emoji
        cell.daysCountLabel.text = daysCompleted(trackerID: trackerID).days()
        cell.trackButton.tag = trackerID
        cell.trackButton.isChecked = buttonIsChecked(trackerID: trackerID)
        cell.trackButton.addTarget(self, action: #selector(trackButtonDidTap(sender:)), for: .touchUpInside)
        cell.trackButton.tintColor = UIColor.ypColorSelection[tracker?.color ?? 0]
        return cell
    }
    
    func buttonIsChecked(trackerID: Int) -> Bool {
        guard let currentDate = viewController?.currentDate else { return false }
        
        guard let recordExists = viewController?.storage?.checkRecordExists(
            trackerID: trackerID,
            date: currentDate
        ) else { return false }
        
        return recordExists
    }
    
    func daysCompleted(trackerID: Int) -> Int {
        let daysCompleted = viewController?.completedTrackers.filter { $0.id == trackerID }
        return daysCompleted?.count ?? 0
    }
    
    @objc
    func trackButtonDidTap(sender: Any) {
        guard let currentDate = viewController?.currentDate.withoutTime() else { return }
        if  currentDate > Date().withoutTime() { return }
        
        let buttonTapped = sender as! TrackButton
        let trackerID = buttonTapped.tag
        buttonTapped.isChecked.toggle()
        viewController?.trackButtonDidTap(trackerID: trackerID)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath) as? TrackersHeader
        guard let header = header else { return TrackersHeader() }
        header.titleLabel.text = viewController?.storage?.getCategoryTitle(section: indexPath.section)
//        viewController?.visibleCategories[indexPath.section].title
        return header
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerHeight: Double = (section == 0 ? 42 : 18)
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
}

extension TrackersView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 9
        return CGSize(width: availableWidth / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension TrackersView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewController?.setView()
        } else {
            viewController?.searchTrackers(text: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewController?.setView()
    }
}
