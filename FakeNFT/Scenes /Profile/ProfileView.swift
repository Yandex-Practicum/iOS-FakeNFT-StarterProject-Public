import UIKit

final class ProfileView: UIView {
    
//MARK: - Elements
    private lazy var userImage: UIImageView = {
        let placeholder = UIImage(named: "UserImagePlaceholder")
        let userImage = UIImageView(image: placeholder)
        userImage.translatesAutoresizingMaskIntoConstraints = false
        return userImage
    }()
    
    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = ""
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        userNameLabel.textColor = .black
        return userNameLabel
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
    
    private lazy var siteAddressLabel: UILabel = {
        let siteAddressLabel = UILabel()
        siteAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        let tapAction = UITapGestureRecognizer(target: self, action:#selector(actionTapped(_:)))
        siteAddressLabel.isUserInteractionEnabled = true
        siteAddressLabel.addGestureRecognizer(tapAction)
        siteAddressLabel.text = ""
        siteAddressLabel.attributedText = NSAttributedString(string: siteAddressLabel.text ?? "", attributes: [.kern: 0.24])
        siteAddressLabel.font = UIFont.systemFont(ofSize: 15)
        siteAddressLabel.textColor = .blue
        return siteAddressLabel
    }()
    
    private lazy var profileAssetsTable: UITableView = {
        let profileAssetsTable = UITableView()
        profileAssetsTable.translatesAutoresizingMaskIntoConstraints = false
        profileAssetsTable.register(ProfileAssetsCell.self, forCellReuseIdentifier: "ProfileAssetsCell")
        profileAssetsTable.dataSource = self
        profileAssetsTable.delegate = self
        profileAssetsTable.separatorStyle = .none
        return profileAssetsTable
    }()


//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
                
        self.backgroundColor = .white
        addUserImage()
        addUsernameLabel()
        addDescriptionLabel()
        addSiteAddressLabel()
        addProfileAssetsTable()
        
        fulfillDummy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Constraints
    private func addUserImage() {
        self.addSubview(userImage)
        NSLayoutConstraint.activate([
            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func addUsernameLabel() {
        self.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: userImage.topAnchor, constant: 21).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16).isActive = true
    }
    
    private func addDescriptionLabel() {
        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
        descriptionLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
        descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
        descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
        descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func addSiteAddressLabel() {
        self.addSubview(siteAddressLabel)
        NSLayoutConstraint.activate([
            siteAddressLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            siteAddressLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            siteAddressLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor)
        ])
    }
    
    private func addProfileAssetsTable() {
        self.addSubview(profileAssetsTable)
        NSLayoutConstraint.activate([
            profileAssetsTable.topAnchor.constraint(equalTo: siteAddressLabel.bottomAnchor, constant: 40),
            profileAssetsTable.heightAnchor.constraint(equalToConstant: 54 * 3),
            profileAssetsTable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileAssetsTable.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    @objc
    func actionTapped(_ sender: UITapGestureRecognizer) {
        print("ok")
    }
    
    // TODO: Remove for prod
    func fulfillDummy() {
        userImage.image = UIImage(named: "UserImageDummy")
        userNameLabel.text = "Joaquin Phoenix"
        descriptionLabel.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        siteAddressLabel.text = "JoaquinPhoenix.com"
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension ProfileView: UITableViewDelegate {
    
}
