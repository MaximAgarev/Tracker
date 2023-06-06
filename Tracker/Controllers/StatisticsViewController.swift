import UIKit

final class StatisticsViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Статистика"
        headerLabel.font = .systemFont(ofSize: 34)
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
        showEmptyTab()
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
    
}
