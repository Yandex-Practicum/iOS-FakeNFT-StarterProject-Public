import UIKit

extension UIViewController {

    func presentErrorDialog(message: String?) {
        let errorDialog = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        errorDialog.addAction(UIAlertAction(title: "Ок", style: .default))
        present(errorDialog, animated: true)
    }

}

