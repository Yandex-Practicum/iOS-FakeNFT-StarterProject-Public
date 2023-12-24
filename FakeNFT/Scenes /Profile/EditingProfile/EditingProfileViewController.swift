
import UIKit

final class EditingProfileViewController: UIViewController {
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark", withConfiguration: boldConfig), for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTapped), for: .touchUpInside)
        button.tintColor = UIColor.ypBlack
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var presenter: EditingProfilePresenterProtocol?

    init(profile: ProfileModelUI) {
        super.init(nibName: nil, bundle: nil)
        presenter = EditingProfilePresenter(profile: profile)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhite
        addSubviews()
        setData()
    }
    
    private func addSubviews() {
        view.addSubview(closeButton)
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            
            avatarImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setData() {
        guard let presenter else { return }
        avatarImageView.image = 
    }
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
}
