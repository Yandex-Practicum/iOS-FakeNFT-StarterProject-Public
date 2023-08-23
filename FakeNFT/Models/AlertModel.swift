import UIKit

struct AlertModel {
    var title: String
    var message: String
    var textField: Bool
    var placeholder: String
    var buttonText: String
    var styleAction: UIAlertAction.Style
    var completion: ((UIAlertAction) -> Void)?
}
