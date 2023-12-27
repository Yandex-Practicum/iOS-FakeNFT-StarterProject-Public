
import UIKit

protocol EditingProfileViewControllerProtocol: AnyObject {
    func updateUI(profile: ProfileModelUI)
}

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
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: avatarImageView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "1A1B22").withAlphaComponent(0.6)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var labelChangePhoto: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Medium", size: 10)
        label.textColor = UIColor.ypwhiteUniversal
        label.text = NSLocalizedString("labelChangePhoto", comment: "")
        label.numberOfLines = 2
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePhotoDidTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Bold", size: 22)
        label.textColor = UIColor.ypBlack
        label.text = NSLocalizedString("name", comment: "")
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.font = UIFont(name: "SFProText-Regular", size: 17)
        textField.backgroundColor = UIColor.ypLightGrey
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:16, height:10))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Bold", size: 22)
        label.textColor = UIColor.ypBlack
        label.text = NSLocalizedString("description", comment: "")
        return label
    }()
    
    private lazy var descriptionText: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.cornerRadius = 12
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.backgroundColor = UIColor.ypLightGrey
        text.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        return text
    }()
    
    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Bold", size: 22)
        label.textColor = UIColor.ypBlack
        label.text = NSLocalizedString("site", comment: "")
        return label
    }()
    
    private lazy var siteTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.font = UIFont(name: "SFProText-Regular", size: 17)
        textField.backgroundColor = UIColor.ypLightGrey
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:16, height:10))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private var presenter: EditingProfilePresenterProtocol?
    
    init(presenter: EditingProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.view = self
        view.backgroundColor = UIColor.ypWhite
        addSubviews()
        presenter?.viewDidLoad()
    }
    
    private func addSubviews() {
        view.addSubview(closeButton)
        view.addSubview(avatarImageView)
        avatarImageView.addSubview(backgroundView)
        backgroundView.addSubview(labelChangePhoto)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionText)
        view.addSubview(descriptionLabel)
        view.addSubview(siteLabel)
        view.addSubview(siteTextField)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            
            avatarImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            
            backgroundView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 70),
            backgroundView.widthAnchor.constraint(equalToConstant: 70),
            
            labelChangePhoto.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            labelChangePhoto.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            labelChangePhoto.heightAnchor.constraint(equalToConstant: 24),
            labelChangePhoto.widthAnchor.constraint(equalToConstant: 45),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 28),
            
            descriptionText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionText.heightAnchor.constraint(equalToConstant: 132),
            
            siteLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            siteLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            siteLabel.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 24),
            siteLabel.heightAnchor.constraint(equalToConstant: 28),
            
            siteTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            siteTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            siteTextField.topAnchor.constraint(equalTo: siteLabel.bottomAnchor, constant: 8),
            siteTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear(
            name: nameTextField.text ?? "",
            description: descriptionText.text,
            website: siteTextField.text ?? "")
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
    }
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc private func changePhotoDidTapped() {
        let alertController = UIAlertController(
            title: NSLocalizedString("alertChangePhoto.title", comment: ""),
            message: nil,
            preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("alertChangePhoto.placeholder", comment: "")
        }

        let doneAction = UIAlertAction(
            title: NSLocalizedString("done", comment: ""),
            style: .default) { [weak self] action in
            if let text = alertController.textFields?.first?.text {
                self?.presenter?.newLinkPhoto = text
            }
        }
        alertController.addAction(doneAction)

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancel", comment: ""),
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension EditingProfileViewController: EditingProfileViewControllerProtocol {
    func updateUI(profile: ProfileModelUI) {
        avatarImageView.image = UIImage(data: profile.avatar ?? Data())
        nameTextField.text = profile.name
        descriptionText.text = profile.description
        siteTextField.text = profile.website
    }
}
