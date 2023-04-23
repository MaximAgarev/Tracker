import UIKit

protocol NewTrackerViewControllerProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    var newTrackerView: NewTrackerViewProtocol? { get set }
    var isHabit: Bool { get set }
    func didTapCreateButton()
    func didTapCancelButton()
}

final class NewTrackerViewController: UIViewController, NewTrackerViewControllerProtocol {
    var newTrackerView: NewTrackerViewProtocol?
    var isHabit: Bool = true
    
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newTrackerView = NewTrackerView(frame: .zero, viewController: self)
        self.view = newTrackerView
        self.newTrackerView = newTrackerView
    }
        
    func didTapCreateButton(){
        print("Create!")
    }
    
    func didTapCancelButton(){
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isHabit ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath as IndexPath) as? CategoryCell
        guard let cell = cell else { return CategoryCell() }
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        cell.titleLabel.text = indexPath.row == 0 ?  "Категория" : "Расписание"
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        indexPath.row == 0 ? presentCategoriesViewController() : presentScheduleViewController()
    }
    
    func presentScheduleViewController() {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        scheduleViewController.modalPresentationStyle = .popover
        self.present(scheduleViewController, animated: true)
    }
    
    func presentCategoriesViewController() {
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.delegate = self
        categoriesViewController.modalPresentationStyle = .popover
        self.present(categoriesViewController, animated: true)
    }
}

extension NewTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell
        guard let cell = cell else { return CollectionCell() }
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        if collectionView.tag == 1 {
            cell.titleLabel.text = emojies[indexPath.row]
        } else {
            cell.titleLabel.backgroundColor = .ypColorSelection[indexPath.row]
        }
        
        return cell
    }
}

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell
        if collectionView.tag == 1 {
            cell?.backgroundColor = .ypLightGray
        } else {
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = CGColor(red: 0.9, green: 0.91, blue: 0.92, alpha: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell
        if collectionView.tag == 1 {
            cell?.backgroundColor = .ypWhite
        } else {
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
