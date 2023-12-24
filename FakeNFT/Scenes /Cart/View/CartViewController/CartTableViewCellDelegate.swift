import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func showDeleteViewController(for index: Int, with image: UIImage)
}
