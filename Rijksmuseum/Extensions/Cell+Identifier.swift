import UIKit

extension UICollectionViewCell {

    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell {

    static var identifier: String {
        return String(describing: Self.self)
    }
}
