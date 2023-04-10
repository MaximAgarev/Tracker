import UIKit

protocol NewTrackerViewControllerProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    var newTrackerView: NewTrackerViewProtocol? { get set }
    var isHabit: Bool { get set }
    func didTapCreateButton()
}

final class NewTrackerViewController: UIViewController, NewTrackerViewControllerProtocol {
    var newTrackerView: NewTrackerViewProtocol?
    var isHabit: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newTrackerView = NewTrackerView(frame: .zero, viewController: self)
        self.view = newTrackerView
    }
    
    func didTapCreateButton(){
        print("Create!")
    }
}

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isHabit ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath as IndexPath)
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        cell.textLabel?.text = indexPath.row == 0 ?  "Категория" : "Расписание"
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
        
        print(tableView.cellForRow(at: indexPath)?.textLabel?.text)
    }
}

extension NewTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as? EmojiCell
        guard let cell = cell else { return EmojiCell() }
        cell.titleLabel.text = emojies[indexPath.row]
        return cell
    }
}

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 24, bottom: 30, right: 24)
    }
}
