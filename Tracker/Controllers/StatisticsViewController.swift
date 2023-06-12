import UIKit

final class StatisticsViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = NSLocalizedString("statisticsTitle", comment: "")
        headerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
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
    
    private lazy var statisticView: UIView = {
        let statisticView = UIView()
        statisticView.translatesAutoresizingMaskIntoConstraints = false
        return statisticView
    }()
    
    var bestPeriodCell: StatisticCell?
    var perfectDaysCell: StatisticCell?
    var completedTrackersCell: StatisticCell?
    var averageValueCell: StatisticCell?
    
    var viewIsEmpty: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        addHeaderLabel()
        setView()
        updateStatistics()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateStatistics),
            name: NSNotification.Name(rawValue: "updateStatistics"),
            object: nil
        )
    }
    
    func setView() {
        if viewIsEmpty {
            emptyImageView.removeFromSuperview()
            emptyLabel.removeFromSuperview()
            showStatisticView()
            viewIsEmpty = false
        } else {
            for view in statisticView.subviews { view.removeFromSuperview() }
            statisticView.removeFromSuperview()
            showEmptyView()
            viewIsEmpty = true
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
    
    func showEmptyView() {
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func showStatisticView() {
        view.addSubview(statisticView)
        addBestPeriod()
        addPerfectDays()
        addCompletedTrackers(count: 0)
        addAverageValue()
        NSLayoutConstraint.activate([
            statisticView.topAnchor.constraint(equalTo: view.topAnchor),
            statisticView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            statisticView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func addBestPeriod() {
        bestPeriodCell = StatisticCell(frame: .zero, count: 0, title: NSLocalizedString("bestPeriod", comment: ""))
        guard let cell = bestPeriodCell else { return }
        statisticView.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: statisticView.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: statisticView.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 77)
        ])
    }
    
    func addPerfectDays() {
        perfectDaysCell = StatisticCell(frame: .zero, count: 0, title: NSLocalizedString("perfectDays", comment: ""))
        guard let cell = perfectDaysCell else { return }
        statisticView.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: statisticView.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: statisticView.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 179)
        ])
    }
    
    func addCompletedTrackers(count: Int) {
        completedTrackersCell = StatisticCell(frame: .zero, count: count, title: NSLocalizedString("completedTrackers", comment: ""))
        guard let cell = completedTrackersCell else { return }
        statisticView.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: statisticView.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: statisticView.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 281)
        ])
    }
    
    func addAverageValue() {
        averageValueCell = StatisticCell(frame: .zero, count: 0, title: NSLocalizedString("averageValue", comment: ""))
        guard let cell = averageValueCell else { return }
        statisticView.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: statisticView.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: statisticView.trailingAnchor, constant: -16),
            cell.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 383)
        ])
    }
    
    @objc
    func updateStatistics() {
        let completedTrackers = TrackerRecordStore().loadCompletedTrackers()
        let statisticIsEmpty = (completedTrackers.count == 0)

        if statisticIsEmpty != viewIsEmpty { setView() }
        
        if !statisticIsEmpty {
            completedTrackersCell?.countLabel.text = String(completedTrackers.count)
        }
    }
}
