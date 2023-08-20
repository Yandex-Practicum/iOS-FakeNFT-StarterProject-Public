import UIKit

final class EditProfileAlertController: UIAlertController {
    private let viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(
            "NFTSortingAlertController -> init(coder:) has not been implemented"
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    private func setupSubViews() {
        title = "Ок"
        self.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Введите ссылку:"
        })
        message = "Укажите ссылку на аватар"
        
        addAction(
            UIAlertAction(
                title: "Ок",
                style: .default
            ){ [weak self] _ in
                guard
                    let self = self,
                    let textField = textFields?[0],
                    let updateURL = textField.text
                else { return }
                
                if UIApplication.shared.canOpenURL(URL(string: updateURL)! as URL) {
                    self.viewModel.updateAvatar(withLink: updateURL)
                } else {
                    let wrongURLAlert = UIAlertController(
                        title: "Неверная ссылка",
                        message: "Проверьте формат ссылки",
                        preferredStyle: .alert)
                    wrongURLAlert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { _ in
                        wrongURLAlert.dismiss(animated: true)
                    }))
                    self.present(wrongURLAlert, animated: true)
                }
                dismiss(animated: true)
            }
        )
        
        addAction(
            UIAlertAction(
                title: "Cancel",
                style: .destructive)
        )
    }
}
