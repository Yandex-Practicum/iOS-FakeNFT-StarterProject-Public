import UIKit

typealias ActionHandler = () -> Void

struct ErrorModel {
    let message: String
    let actionText: String
    let action: ActionHandler?
}

protocol ErrorView {
    func showError(with model: ErrorModel)
    func errorModel(_ error: Error, action: ActionHandler?) -> ErrorModel
}

extension ErrorView where Self: UIViewController {
    
    func showError(with model: ErrorModel) {
        let title = NSLocalizedString("Error.title", comment: "")
        let alert = UIAlertController(
            title: title,
            message: model.message,
            preferredStyle: .alert
        )
        
        if let action = model.action {
            
            let alertAction = UIAlertAction(title: model.actionText,
                                      style: UIAlertAction.Style.default) {_ in
                action()
            }
            
            alert.addAction(alertAction)
        }
        
        present(alert, animated: true)
    }
    
    func errorModel(_ error: Error, action: ActionHandler? = nil) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "") // или "Произошла ошибка сети"
        default:
            message = NSLocalizedString("Error.unknown", comment: "") // или "Произошла неизвестная ошибка"
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "") // или "Повторить"
        
        return ErrorModel(
            message: message,
            actionText: actionText,
            action: action
        )
    }
}
