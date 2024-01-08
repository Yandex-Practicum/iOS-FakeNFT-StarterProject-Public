import UIKit

extension UIViewController {

    func setupCustomBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(self.customBackAction)
        )
    }

    @objc
    func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
