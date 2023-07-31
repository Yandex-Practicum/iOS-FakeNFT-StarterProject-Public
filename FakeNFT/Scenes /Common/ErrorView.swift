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
    let alert = UIAlertController(title: "Ошибка", message: model.message, preferredStyle: .alert)
    let action = UIAlertAction(title: model.actionText, style: UIAlertAction.Style.default) {_ in
      model.action()
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
}
