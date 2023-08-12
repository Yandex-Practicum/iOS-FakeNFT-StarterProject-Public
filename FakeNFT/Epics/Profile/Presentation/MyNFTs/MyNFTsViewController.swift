import UIKit

final class MyNFTsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypGrayUniversal
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        title = NSLocalizedString("profile.myNFTs", comment: "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.bodyBold,
            .foregroundColor: UIColor.ypBlack
        ]
        
        // Создание кнопки "Назад"
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: symbolConfiguration) ?? UIImage()
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
        
        // Создание кнопки с изображением справа
        let imageButton = UIBarButtonItem(image: UIImage(named: "yourImageName"), style: .plain, target: self, action: #selector(imageButtonTapped))
        navigationItem.rightBarButtonItem = imageButton
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func imageButtonTapped() {
        // Действие, которое нужно выполнить при нажатии на кнопку с изображением
    }
}
