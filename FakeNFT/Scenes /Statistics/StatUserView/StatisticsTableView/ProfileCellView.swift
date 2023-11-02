import UIKit

class ProfileCellView: UIView {
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return profilePhoto.kf.cancelDownloadTask()
            }

            profilePhoto.kf.setImage(with: url)
        }
    }

    var text: String? {
        didSet {
            profileName.text = text
        }
    }

    var counter: Int? {
        didSet {
            profileNFTCount.text = counter.map { "\($0)" } ?? ""
        }
    }

    private let profilePhoto: UIImageView = {
        let profilePhoto = UIImageView()
        profilePhoto.layer.cornerRadius = 14
        profilePhoto.layer.masksToBounds = true
        profilePhoto.image = UIImage(systemName: "person.crop.circle.fill")?
            .withTintColor(.textSecondary)
            .withRenderingMode(.alwaysOriginal)
        return profilePhoto
    }()

    private let profileName: UILabel = {
        let profileName = UILabel()
        profileName.font = .headline3
        profileName.textColor = .ypBlack
        return profileName
    }()

    private let profileNFTCount: UILabel = {
        let profileNFTCount = UILabel()
        profileNFTCount.font = .headline3
        return profileNFTCount
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .ypLightGrey
        layer.cornerRadius = 12

        let hStack = UIStackView(arrangedSubviews: [profilePhoto, profileName])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 8
        addSubview(hStack)

        addSubview(profileNFTCount)
        profileNFTCount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileNFTCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            profileNFTCount.centerYAnchor.constraint(equalTo: centerYAnchor),
            hStack.trailingAnchor.constraint(lessThanOrEqualTo: profileNFTCount.leadingAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: 28),
            profilePhoto.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
