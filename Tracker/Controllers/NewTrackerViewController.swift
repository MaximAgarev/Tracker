import UIKit

protocol NewTrackerViewControllerProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    var storage: TrackerStorageProtocol? { get set }
    var newTrackerView: NewTrackerViewProtocol? { get set }
    var isHabit: Bool { get set }
    var editTracker: Tracker? { get set }
    
    var category: String { get set }
    var trackerParams: TrackerParams { get set }
        
    func didTapCreateButton()
    func didTapCancelButton()
}

final class NewTrackerViewController: UIViewController, NewTrackerViewControllerProtocol {
    var storage: TrackerStorageProtocol?
    var newTrackerView: NewTrackerViewProtocol?
    var isHabit: Bool = true
    var editTracker: Tracker?
    
    var category: String = ""
    var trackerParams: TrackerParams = TrackerParams(id: 0, title: "", schedule: "", emoji: "", color: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newTrackerView = NewTrackerView(frame: .zero, viewController: self)
        self.view = newTrackerView
        self.newTrackerView = newTrackerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if editTracker != nil {
            
            guard let editTracker = editTracker,
                  let emojiIndex = emojies.firstIndex(of: editTracker.emoji) else { return }
            
            (view as? NewTrackerView)?.fulfillEditedTracker(
                title: editTracker.title,
                category: category,
                schedule: editTracker.schedule,
                emoji: emojiIndex,
                color: editTracker.color
            )
            
            trackerParams.id = editTracker.id
            trackerParams.title = editTracker.title
            trackerParams.schedule = editTracker.schedule
            trackerParams.emoji = editTracker.emoji
            trackerParams.color = editTracker.color
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    func didTapCreateButton(){
        storage = TrackerStorageCoreData.shared
        guard let storage = storage else { return }
        
        let tracker = Tracker(
            id: trackerParams.id == 0 ? storage.trackerID() : trackerParams.id,
            title: trackerParams.title,
            schedule: trackerParams.schedule,
            emoji: trackerParams.emoji,
            color: trackerParams.color
        )

        storage.saveTracker(tracker: tracker, categoryTitle: category)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTrackers"), object: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func didTapCancelButton(){
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Category & Schedule table
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
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? CategoryCell
        let selected = cell?.valueLabel.text
        indexPath.row == 0 ? presentCategoriesViewController(selected: selected ?? nil) : presentScheduleViewController(selected: selected ?? nil)
    }
    
    func presentScheduleViewController(selected: String?) {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        scheduleViewController.selectedSchedule = selected
        scheduleViewController.modalPresentationStyle = .popover
        self.present(scheduleViewController, animated: true)
    }
    
    func presentCategoriesViewController(selected: String?) {
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.delegate = self
        categoriesViewController.selectedCategory = selected
        categoriesViewController.modalPresentationStyle = .popover
        self.present(categoriesViewController, animated: true)
    }
}

// MARK: - Emoji & Color collection
extension NewTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell
        guard let cell = cell else { return CollectionCell() }
        cell.layer.cornerRadius = 14
        cell.layer.masksToBounds = true
        
        let view = collectionView as? EmojiColorCollectionView
        if view?.collectionType == .emoji {
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
        self.view.endEditing(true)
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell
        let view = collectionView as? EmojiColorCollectionView
        if view?.collectionType == .emoji {
            cell?.backgroundColor = .ypLightGray
            trackerParams.emoji = cell?.titleLabel.text ?? ""
            newTrackerView?.createButtonAvailability(element: "emoji", state: true)
        } else {
            cell?.layer.borderWidth = 3
            if let color = cell?.titleLabel.backgroundColor {
                trackerParams.color = UIColor.ypColorSelection.firstIndex(of: color) ?? 0
                let borderColor = color.withAlphaComponent(0.3)
                cell?.layer.borderColor = borderColor.cgColor
            }
            newTrackerView?.createButtonAvailability(element: "color", state: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell
        let view = collectionView as? EmojiColorCollectionView
        if view?.collectionType == .emoji {
            cell?.backgroundColor = .ypWhite
        } else {
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
