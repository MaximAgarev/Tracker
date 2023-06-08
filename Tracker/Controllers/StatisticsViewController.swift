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
    
    var bestPeriodCell: StatisticCell?
    var perfectDaysCell: StatisticCell?
    var completedTrackersCell: StatisticCell?
    var averageValue: StatisticCell?
    
    
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateStatistics),
            name: NSNotification.Name(rawValue: "updateStatistics"),
            object: nil
        )
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
        bestPeriodCell = StatisticCell(frame: .zero, count: 0, title: "Лучший период")
        guard let cell = bestPeriodCell else { return }
        view.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 77)
        ])
    }
    
    func addPerfectDays() {
        perfectDaysCell = StatisticCell(frame: .zero, count: 0, title: "Идеальные дни")
        guard let cell = perfectDaysCell else { return }
        view.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 179)
        ])
    }
    
    func addCompletedTrackers(count: Int) {
        completedTrackersCell = StatisticCell(frame: .zero, count: count, title: "Трекеров завершено")
        guard let cell = completedTrackersCell else { return }
        view.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 281)
        ])
    }
    
    func addAverageValue() {
        averageValue = StatisticCell(frame: .zero, count: 0, title: "Среднее значение")
        guard let cell = averageValue else { return }
        view.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 383)
        ])
    }
    
    @objc
    func updateStatistics() {
        let completedTrackers = TrackerRecordStore().loadCompletedTrackers()
        completedTrackersCell?.countLabel.text = String(completedTrackers.count)
    }
    
}
