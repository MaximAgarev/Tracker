import UIKit

final class CreateTrackerButton: UIButton {
    var titleEntered: Bool = false { didSet {checkSettingsCompleted()} }
    var categorySelected: Bool = false { didSet {checkSettingsCompleted()} }
    var scheduleSelected: Bool = false { didSet {checkSettingsCompleted()} }
    var emojiSelected: Bool = false { didSet {checkSettingsCompleted()} }
    var colorSelected: Bool = false { didSet {checkSettingsCompleted()} }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func checkSettingsCompleted() {
        if titleEntered,
           categorySelected,
           scheduleSelected,
           emojiSelected,
           colorSelected {
            self.backgroundColor = .ypBlack
            self.isEnabled = true
        } else {
            self.backgroundColor = .ypGray
            self.isEnabled = false
        }
    }
}
