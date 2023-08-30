import UIKit
import Firebase

final class SplashScreenViewController: UIViewController {
    
    // MARK: - UI:
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        let image = Resources.Images.SplashScreen.logo
        imageView.image = image
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthToken()
    }
    
    // MARK: Private Methods:
    private func checkAuthToken() {
        Auth.auth().addStateDidChangeListener { [weak self] (_ , user) in
            guard let self = self else { return }
            if user != nil {
                self.switchToTabBarController()
            } else {
                self.switchToAuthViewController()
            }
        }
    }
    
    private func switchToAuthViewController() {
        let viewModel = AuthViewModel()
        let viewController = AuthViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: true)
    }
    
    private func switchToTabBarController() {
        let viewController = TabBarController()
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: true)
    }
}

// MARK: - Setup Views:
extension SplashScreenViewController {
    private func setupViews() {
        view.setupView(logoImageView)
    }
}

// MARK: - Setup Constraints:
extension SplashScreenViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
