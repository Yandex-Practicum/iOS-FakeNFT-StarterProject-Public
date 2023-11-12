import UIKit

protocol AlertServiceProtocol {
    func showChangePhotoURLAlert(with title: String?,
                                 message: String?,
                                 textFieldPlaceholder: String?,
                                 confirmAction: @escaping (String?) -> Void)

    func showAvatarChangeError()
}

class AlertService: AlertServiceProtocol {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showChangePhotoURLAlert(with title: String?,
                                 message: String?,
                                 textFieldPlaceholder: String?,
                                 confirmAction: @escaping (String?) -> Void) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = textFieldPlaceholder
        }

        let confirmAction = UIAlertAction(title: "Подтвердить", style: .default) { _ in
            let text = alertController.textFields?.first?.text
            confirmAction(text)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        viewController?.present(alertController, animated: true, completion: nil)
    }

    func showAvatarChangeError() {
        let alertController = UIAlertController(title: "Введен не корретный URL адрес",
                                                message: "Адрес должен быть формата https://example.com/photo.img",
                                                preferredStyle: .alert)

        let confirm = UIAlertAction(title: "Ок", style: .cancel, handler: nil)

        alertController.addAction(confirm)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
