import UIKit

final class TrackButton: UIButton {
    var trackerID: Int?
    
    var isChecked: Bool = false {
        didSet {
            let imageName = self.isChecked ? "Track Button Check Image" : "Track Button Plus Image"
            setImage(imageName: imageName)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 17
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(imageName: String) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
    }
}
