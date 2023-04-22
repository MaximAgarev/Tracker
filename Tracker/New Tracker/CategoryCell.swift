import UIKit

final class CategoryCell: UITableViewCell {
    var titleLabel = UILabel()
    var valueLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .ypBlack
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .systemFont(ofSize: 17)
        valueLabel.textColor = .ypGray
        
        oneRow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func oneRow() {
        titleLabel.removeFromSuperview()
        valueLabel.removeFromSuperview()
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
                    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    titleLabel.heightAnchor.constraint(equalToConstant: 22),
                    titleLabel.widthAnchor.constraint(equalToConstant: 271)
                ])
    }
    
    func twoRows() {
        titleLabel.removeFromSuperview()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
                
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
}
