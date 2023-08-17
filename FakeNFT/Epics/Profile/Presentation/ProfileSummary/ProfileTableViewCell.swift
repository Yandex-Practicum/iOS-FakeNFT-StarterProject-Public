import UIKit

final class ProfileTableViewCell: UITableViewCell, ReuseIdentifying {
    // MARK: - Private properties
    
    private let titleLabel = UILabel()
    private let chevronView = UIImageView()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.contentMode = .scaleAspectFit
        stack.axis = .horizontal
        stack.layer.masksToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Life cicle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        layoutConfigure()
        configureChevronView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Public methods
    
    func configure(title: String) {
        configureTitleLabel(with: title)
    }
    
    // MARK: - Private methods
    
    private func layoutConfigure() {
        contentView.addSubview(stackView)
        
        stackView.addSubview(chevronView)
        stackView.addSubview(titleLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            chevronView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            chevronView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
    }
    
    private func configureTitleLabel(with text: String) {
        titleLabel.text = text
        titleLabel.font = .bodyBold
        titleLabel.textColor = .ypBlack
        titleLabel.textAlignment = .left
    }
    
    private func configureChevronView() {
        let chevronImage = UIImage(systemName: "chevron.forward")
        chevronView.image = chevronImage
        chevronView.tintColor = .ypBlack
        chevronView.layer.masksToBounds = true
        chevronView.frame.size = CGSize(width: 7.98, height: 13.86)
    }
}
