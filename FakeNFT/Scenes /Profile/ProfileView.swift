import UIKit
import Kingfisher

final class ProfileView: UIView {
    private var viewController: ProfileViewController?
    
    // MARK: - Properties
    private lazy var avatarImage: UIImageView = {
        let placeholder = UIImage(named: "UserImagePlaceholder")
        let avatarImage = UIImageView(image: placeholder)
                avatarImage.translatesAutoresizingMaskIntoConstraints = false
                avatarImage.layer.cornerRadius = 35
                avatarImage.layer.masksToBounds = true
        return avatarImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = ""
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = ""
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 18
        descriptionLabel.attributedText = NSAttributedString(string: descriptionLabel.text ?? "", attributes: [.kern: 0.08, NSAttributedString.Key.paragraphStyle : paragraphStyle])
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .black
        return descriptionLabel
    }()
    
    private lazy var websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        let tapAction = UITapGestureRecognizer(target: self, action:#selector(websiteDidTap(_:)))
        websiteLabel.isUserInteractionEnabled = true
        websiteLabel.addGestureRecognizer(tapAction)
        websiteLabel.text = ""
        websiteLabel.attributedText = NSAttributedString(string: websiteLabel.text ?? "", attributes: [.kern: 0.24])
        websiteLabel.font = UIFont.systemFont(ofSize: 15)
        websiteLabel.textColor = .blue
        return websiteLabel
    }()
    
    private lazy var profileAssetsTable: UITableView = {
        let profileAssetsTable = UITableView()
        profileAssetsTable.translatesAutoresizingMaskIntoConstraints = false
        profileAssetsTable.register(ProfileAssetsCell.self, forCellReuseIdentifier: "ProfileAssetsCell")
        profileAssetsTable.dataSource = self
        profileAssetsTable.delegate = self
        profileAssetsTable.separatorStyle = .none
        profileAssetsTable.allowsMultipleSelection = false
        return profileAssetsTable
    }()
    
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewController: ProfileViewController) {
        super.init(frame: .zero)
        self.viewController = viewController
        
        self.backgroundColor = .white
        addUserImage()
        addUsernameLabel()
        addDescriptionLabel()
        addWebsiteLabel()
        addProfileAssetsTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Constraints
    private func addUserImage() {
        self.addSubview(avatarImage)
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func addUsernameLabel() {
        self.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor, constant: 21).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16).isActive = true
    }
    
    private func addDescriptionLabel() {
        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func addWebsiteLabel() {
        self.addSubview(websiteLabel)
        NSLayoutConstraint.activate([
            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
//            websiteLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor)
        ])
    }
    
    private func addProfileAssetsTable() {
        self.addSubview(profileAssetsTable)
        NSLayoutConstraint.activate([
            profileAssetsTable.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 40),
            profileAssetsTable.heightAnchor.constraint(equalToConstant: 54 * 3),
            profileAssetsTable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileAssetsTable.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    @objc
    func websiteDidTap(_ sender: UITapGestureRecognizer) {
        viewController?.present(WebsiteViewController(webView: nil, websiteURL: websiteLabel.text), animated: true)
    }
    
    func updateViews(userImageURL: URL?, userName: String?, description: String?, website: String?, nftCount: String?, likesCount: String?) {
        avatarImage.kf.setImage(
            with: userImageURL,
            placeholder: UIImage(named: "UserImagePlaceholder"),
            options: [.processor(RoundCornerImageProcessor(cornerRadius: 35))])
        nameLabel.text = userName
        descriptionLabel.text = description
        websiteLabel.text = website
        let nftsCountLabel = profileAssetsTable.cellForRow(at: [0,0]) as? ProfileAssetsCell
        nftsCountLabel?.assetValue.text = nftCount
        let likesCountLabel = profileAssetsTable.cellForRow(at: [0,1]) as? ProfileAssetsCell
        likesCountLabel?.assetValue.text = likesCount
    }
}

extension ProfileView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAssetsCell", for: indexPath as IndexPath) as? ProfileAssetsCell else { return ProfileAssetsCell() }
        switch indexPath.row {
        case 0:
            cell.assetLabel.text = "Мои NFT"
            cell.assetValue.text = "(0)"
        case 1:
            cell.assetLabel.text = "Избранные NFT"
            cell.assetValue.text = "(0)"
        case 2:
            cell.assetLabel.text = "О разработчике"
            cell.assetValue.text = ""
        default:
            cell.assetLabel.text = ""
            cell.assetValue.text = ""
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension ProfileView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Мои NFT")
        case 1:
            print("Избранные NFT")
        case 2:
            print("О разработчике")
        default:
            return
        }
    }
}
