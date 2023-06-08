import UIKit

final class StatisticCell: UIView {
    var count: Int
    var title: String
    
    let countLabel: UILabel = UILabel()
    let titleLabel: UILabel = UILabel()
    
    init(frame: CGRect, count: Int, title: String) {
        self.count = count
        self.title = title
        
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
//        self.layer.borderWidth = 1
//        self.layer.borderColor =
        self.heightAnchor.constraint(equalToConstant: 90).isActive = true
        

        
        setCountLabel()
        setTitleLabel()
        
        self.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCountLabel() {
        addSubview(countLabel)
        countLabel.font = .boldSystemFont(ofSize: 34)
        countLabel.textColor = .ypBlack
        countLabel.text = String(count)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
        ])
    }
    
    private func setTitleLabel() {
        addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .ypBlack
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16)
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: frame.size)
        gradient.startPoint = CGPoint(x: 1.0, y: 0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0)
        gradient.colors = [
            UIColor.ypColorSelection[2].cgColor,
            UIColor.ypColorSelection[8].cgColor,
            UIColor.ypColorSelection[0].cgColor
        ]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        layer.insertSublayer(gradient, at: 0)
    }
}
