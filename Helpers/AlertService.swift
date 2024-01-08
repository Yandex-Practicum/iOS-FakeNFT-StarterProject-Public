import UIKit

struct AlertActionModel {
    let title: String
    let style: UIAlertAction.Style
    let handler: ((String?) -> Void)?
}

struct AlertProfileModel {
    let title: String?
    let message: String?
    let style: UIAlertController.Style
    let actions: [AlertActionModel]
    let textFieldPlaceholder: String?
}

protocol AlertServiceProtocol {
    func showAlert(model: AlertProfileModel)
}

class AlertService: AlertServiceProtocol {
    private weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    func showAlert(model: AlertProfileModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: model.style
        )
        if let placeholder = model.textFieldPlaceholder {
            alertController.addTextField { textField in
                textField.placeholder = placeholder
            }
        }
        model.actions.forEach { actionModel in
            let action = UIAlertAction(title: actionModel.title, style: actionModel.style) { _ in
                if let textField = alertController.textFields?.first {
                    actionModel.handler?(textField.text)
                } else {
                    actionModel.handler?(nil)
                }
            }
            alertController.addAction(action)
        }
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
