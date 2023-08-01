import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Private properties
    private let mainStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.contentMode = .scaleAspectFit
        stack.axis = .vertical
        stack.spacing = 20
        stack.layer.masksToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let photoAndNameStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.contentMode = .scaleAspectFit
        stack.axis = .horizontal
        stack.spacing = 16
        stack.layer.masksToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let photoView: UIImageView = {
        let view = UIImageView(image: .mockUserImage)
        view.layer.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: ProfileConstants.profilePhotoSideSize,
                height: ProfileConstants.profilePhotoSideSize
            )
        )
        view.layer.cornerRadius = ProfileConstants.profilePhotoSideSize/2
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .headline3
        label.text = ProfileConstants.mockProfileName
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption2
        label.text = ProfileConstants.mockProfileDescription
        label.textAlignment = .left
        label.numberOfLines = 0
        
        let lineHeightPoints: CGFloat = 18.0
        let lineHeightPixels = lineHeightPoints / UIScreen.main.scale
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeightPixels
        let attributedText = NSAttributedString(string: label.text ?? "", attributes: [.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText
        
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let userSiteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlueUniversal
        label.font = .caption1
        label.text = ProfileConstants.mockProfileSite
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tableView = UITableView()
    
    private lazy var editProfileButton: UIButton = {
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        let button = UIButton.systemButton(
            with: UIImage(systemName: "square.and.pencil", withConfiguration: symbolConfiguration) ?? UIImage(),
            target: self,
            action: #selector(didTapEditProfileButton)
        )
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addingUIElements()
        tableViewConfigure()
        layoutConfigure()
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        view.addSubview(mainStack)
        
        mainStack.addSubview(editProfileButton)
        mainStack.addSubview(photoAndNameStack)
        mainStack.addSubview(userDescriptionLabel)
        mainStack.addSubview(userSiteLabel)
        mainStack.addSubview(tableView)
        
        photoAndNameStack.addSubview(photoView)
        photoAndNameStack.addSubview(userNameLabel)
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            editProfileButton.topAnchor.constraint(equalTo: mainStack.topAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            photoAndNameStack.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20),
            photoAndNameStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            photoAndNameStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            photoAndNameStack.heightAnchor.constraint(equalToConstant: ProfileConstants.profilePhotoSideSize),
            
            photoView.widthAnchor.constraint(equalToConstant: ProfileConstants.profilePhotoSideSize),
            photoView.heightAnchor.constraint(equalToConstant: ProfileConstants.profilePhotoSideSize),
            photoView.leadingAnchor.constraint(equalTo: photoAndNameStack.leadingAnchor),
            
            userNameLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            userNameLabel.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            
            userDescriptionLabel.topAnchor.constraint(equalTo: photoAndNameStack.bottomAnchor, constant: 20),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            userDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userDescriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            
            userSiteLabel.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 12),
            userSiteLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            userSiteLabel.heightAnchor.constraint(equalToConstant: 20),
            
            tableView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: userSiteLabel.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: ProfileConstants.tableHeight),
            tableView.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor)
        ])
    }
    
    private func tableViewConfigure(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: - Actions
    @objc private func didTapEditProfileButton(){
        print("‼️")
    }
}

extension ProfileViewController: UITableViewDelegate {}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ProfileConstants.mockArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.identifier,
            for: indexPath
        ) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.configure(title: ProfileConstants.mockArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ProfileConstants.tableCellHeight
    }
}
