import UIKit

class TrackersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setNavigationBar()
        

        
    }
    
    private func setNavigationBar() {
        guard let navigationController = navigationController else { return }
        let navigationBar = navigationController.navigationBar
        navigationBar.insetsLayoutMarginsFromSafeArea = false
        
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
        navigationBar.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 47),
            datePicker.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16)
        ])
        
        // Search bar
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.clearButtonMode = .never
        navigationItem.searchController = searchController
    }
    
    func setCollection() {
        
    }
    
    @objc
    func didTapAddTracker() {
        print("Tap!")
    }


}

