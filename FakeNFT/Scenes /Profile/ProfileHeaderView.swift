import UIKit
import Kingfisher

final class ProfileHeaderView: UIView {
    
    // MARK: - UI Элементы
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35 // 70x70 / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Bold", size: 22) ?? .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(named: "YPBlack") ?? .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Regular", size: 13) ?? .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "YPBlack") ?? .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal) // В макете ссылка синяя
        button.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15) ?? .systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(websiteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Аватар (70x70), отступ слева 16, сверху 20
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // Имя (по центру аватарки, отступ 16 от правого края аватарки)
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Описание (под аватаром, отступ 20)
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Ссылка на сайт (под описанием, отступ 8)
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            websiteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Configure
    func configure(with profile: Profile) {
        nameLabel.text = profile.name
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5 // line-height 18 из Figma
        descriptionLabel.attributedText = NSAttributedString(
            string: profile.description ?? "",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont(name: "SFProText-Regular", size: 13) ?? .systemFont(ofSize: 13),
                .foregroundColor: UIColor(named: "YPBlack") ?? .black
            ]
        )
        
        websiteButton.setTitle(profile.website, for: .normal)
        
        if let urlString = profile.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            let placeholder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.2))])
        }
    }
}
