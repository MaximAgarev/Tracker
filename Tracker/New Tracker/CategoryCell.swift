import UIKit

final class CategoryCell: UITableViewCell {
    var titleLabel = UILabel()
    var valueLabel = UILabel()
//    var choiceSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .ypBlack
        NSLayoutConstraint.activate([
                           titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                           titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                           titleLabel.heightAnchor.constraint(equalToConstant: 22),
                           titleLabel.widthAnchor.constraint(equalToConstant: 271)
                       ])
        
        
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addValue() {
        titleLabel.removeFromSuperview()
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .systemFont(ofSize: 17)
        valueLabel.textColor = .ypGray
                
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
//    func addSwitch() {
//        contentView.addSubview(choiceSwitch)
//
//        choiceSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
//        choiceSwitch.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            choiceSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            choiceSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
//        ])
//    }
}
