import UIKit

protocol TrackersViewProtocol: AnyObject {
    var viewController: TrackersViewControllerProtocol? { get set }
    
    func setNavigationBar()
    func setTrackersCollection(isEmpty: Bool)
}


final class TrackersView: UIView, TrackersViewProtocol {
    
    weak var viewController: TrackersViewControllerProtocol?
    var navigationController: UINavigationController?
    var navigationItem: UINavigationItem?
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(TrackersCell.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.register(TrackersHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryHeader")
        return collectionView
    }()
    
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
    
// MARK: - Navigation Bar
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        // Search bar
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchTextField.clearButtonMode = .never
        // TODO: Make delegate
        navigationItem.searchController = searchController
    }
    
    @objc
    func didTapAddTracker() {
        viewController?.presentNewTrackerViewController()
    }
    
// MARK: - Trackers Collection
    func setTrackersCollection(isEmpty: Bool) {
        
        if isEmpty {
            showEmptyTab()
            return
        }

        setCollectionView()
    }
    
    func showEmptyTab() {
        let emptyImage = UIImage(named: "Empty Trackers Tab Image")
        let emptyImageView = UIImageView(image: emptyImage)
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyImageView)

        let emptyLabel =  UILabel()
        emptyLabel.text = "Что будем отслеживать?"
        emptyLabel.font = .systemFont(ofSize: 12)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 402),
            emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 182),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension TrackersView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewController = viewController else { return 0 }
        return viewController.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewController = viewController else { return 0 }
        let trackers = viewController.categories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! TrackersCell
        let tracker = viewController?.categories[indexPath.section].trackers[indexPath.row]
        cell.colorCard.backgroundColor = tracker?.color
        cell.titleLabel.text = tracker?.title
        cell.emodjiLabel.text = tracker?.emoji
        cell.trackButton.isChecked = false
        cell.trackButton.tintColor = tracker?.color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath) as? TrackersHeader
        view?.titleLabel.text = viewController?.categories[indexPath.section].title
        return view!
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
}
