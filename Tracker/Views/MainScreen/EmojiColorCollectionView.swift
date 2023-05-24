import UIKit

class EmojiColorCollectionView: UICollectionView {
    enum collectionType {
        case emoji
        case color
    }
    
    var collectionType: collectionType = .emoji
    
}
