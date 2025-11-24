import UIKit

struct ErrorModel {
    let message: String
    let actionText: String
    let action: () -> Void
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        let title = NSLocalizedString("Error.title", comment: "")
        let alert = UIAlertController(
            title: title,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: model.actionText, style: UIAlertAction.Style.default) {_ in
            model.action()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showFilterActionSheet(firstAction: UIAlertAction, secondAction: UIAlertAction, thirdAction: UIAlertAction?) {
        let titleOfActionSheet = NSLocalizedString("Filter.actionSheet.title", comment: "")
        
        let alert = UIAlertController(
            title: titleOfActionSheet,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let textOfCancelButton = NSLocalizedString("Filter.actionSheet.closeButton.text", comment: "")
        let cancelAction = UIAlertAction(title: textOfCancelButton, style: .cancel)
        
        if let thirdAction = thirdAction {
            [firstAction, secondAction, thirdAction, cancelAction].forEach { alert.addAction($0) }
        } else {
            [firstAction, secondAction, cancelAction].forEach { alert.addAction($0) }
        }
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY,
                width: 0,
                height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
}
