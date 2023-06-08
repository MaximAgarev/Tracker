import UIKit

final class StatisticsViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Статистика"
        headerLabel.font = .boldSystemFont(ofSize: 34)
        headerLabel.textColor = .ypBlack
        return headerLabel
    }()
    
    private lazy var emptyImageView: UIImageView = {
        var emptyImage = UIImage(named: "Empty Statistics Image")
        var emptyImageView = UIImageView(image: emptyImage)
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        return emptyImageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let emptyLabel =  UILabel()
        emptyLabel.text = "Анализировать пока нечего"
        emptyLabel.font = .systemFont(ofSize: 12)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        return emptyLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        let completedTrackers = TrackerRecordStore().loadCompletedTrackers()
        
        addHeaderLabel()
        if completedTrackers.count == 0 {
            showEmptyTab()
        } else {
            addBestPeriod()
            addPerfectDays()
            addCompletedTrackers(count: completedTrackers.count)
            addAverageValue()
        }
    }
    
    func addHeaderLabel() {
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
    }
    
    func showEmptyTab() {
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addBestPeriod() {
        let cell = StatisticCell(frame: .zero, count: 0, title: "Лучший период")
        view.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 77)
        ])
    }
    
    func addPerfectDays() {
        let cell = StatisticCell(frame: .zero, count: 0, title: "Идеальные дни")
        view.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 179)
        ])
    }
    
    func addCompletedTrackers(count: Int) {
        let cell = StatisticCell(frame: .zero, count: count, title: "Трекеров завершено")
        view.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 281)
        ])
    }
    
    func addAverageValue() {
        let cell = StatisticCell(frame: .zero, count: 0, title: "Среднее значение")
        view.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 383)
        ])
    }
    
}
