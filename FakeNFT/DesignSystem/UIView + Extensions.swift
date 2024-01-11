import UIKit

extension UIView {
    func addViewWithNoTAMIC(_ views: UIView) {
        self.addSubview(views)
        views.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIView {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    private var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }

    @objc
    private func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
}

extension UIViewController {

    func setupCustomBackButton() {
        let backButtonImage = UIImage(named: "backward")?.withRenderingMode(.alwaysTemplate)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backButtonImage,
            style: .plain,
            target: self,
            action: #selector(self.customBackAction)
        )

        navigationItem.leftBarButtonItem?.tintColor = .black
    }

    @objc
    func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
