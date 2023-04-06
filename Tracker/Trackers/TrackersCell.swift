import UIKit

final class TrackersCell: UICollectionViewCell {
    
    let colorCard: UIView = UIView()
    let emodjiLabel: UILabel = UILabel()
    let titleLabel: UILabel = UILabel()
    let trackButton: TrackButton = TrackButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setColorCard()
        setTitle()
        setEmoji()
        setTrackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColorCard() {
        colorCard.layer.cornerRadius = 16
        colorCard.layer.masksToBounds = true
        contentView.addSubview(colorCard)
        colorCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorCard.heightAnchor.constraint(equalToConstant: 90),
            colorCard.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            colorCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            ])
    }
    
    func setTitle() {
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .ypWhite
        colorCard.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: colorCard.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: colorCard.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: colorCard.bottomAnchor, constant: -12),
        ])
    }
    
    func setEmoji() {
        emodjiLabel.backgroundColor = .white.withAlphaComponent(0.3)
        emodjiLabel.font = .systemFont(ofSize: 12)
        emodjiLabel.textAlignment = .center
        emodjiLabel.layer.cornerRadius = 12
        emodjiLabel.layer.masksToBounds = true
        colorCard.addSubview(emodjiLabel)
        emodjiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emodjiLabel.heightAnchor.constraint(equalToConstant: 24),
            emodjiLabel.widthAnchor.constraint(equalToConstant: 24),
            emodjiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emodjiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
            ])
    }
    
    func setTrackButton() {
        addSubview(trackButton)
        trackButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackButton.topAnchor.constraint(equalTo: colorCard.bottomAnchor, constant: 8),
            trackButton.trailingAnchor.constraint(equalTo: colorCard.trailingAnchor, constant: -12),
            trackButton.heightAnchor.constraint(equalToConstant: 34),
            trackButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
}
