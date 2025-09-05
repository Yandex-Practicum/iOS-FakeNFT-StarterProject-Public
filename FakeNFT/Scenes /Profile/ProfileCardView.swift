import UIKit
import Kingfisher

final class ProfileCardView: UIView {
    //MARK: UI
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: LayoutConstants.avatarSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: LayoutConstants.avatarSize).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLink), for: .touchUpInside)
        return button
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [horizontalStackView, bioLabel, linkButton])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = LayoutConstants.spacingXXL
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var urlString: String?
    //MARK: Closure
    var onLinkTapped: (() -> Void)?
    
    // MARK: init
    override init(frame: CGRect){
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with profile: Profile) {
        nameLabel.text = profile.name
        bioLabel.text = profile.description
        
        if let website = profile.website {
            urlString = website
            linkButton.setTitle(website, for: .normal)
            linkButton.isHidden = false
        } else {
            linkButton.setTitle(nil, for: .normal)
            linkButton.isHidden = true
        }
        
        let placeholderImage = UIImage(named: "no_avatar")
        
        if let url = URL(string: profile.avatar) {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(
                with: url,
                placeholder: placeholderImage
            )
        } else {
            profileImageView.image = placeholderImage
        }
    }
    
    private func setupUI(){
        addSubview(verticalStackView)
        verticalStackView.setCustomSpacing(12, after: bioLabel)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.horizontalPadding),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.horizontalPadding),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    func didTapLink(){
        onLinkTapped?()
    }
    
}
