import UIKit

final class ProfileAssetsCell: UITableViewCell, ReuseIdentifying {
    private lazy var assetLabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var assetValueLabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var disclosureIndicator = {
        var imageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        imageView.tintColor = .appBlack
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 17))
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAssets(label: String? = nil, value: String?) {
        if let label = label { assetLabel.text = label }
        if let value = value { assetValueLabel.text = value }
    }
    
    private func setupConstraint() {
        [assetLabel, assetValueLabel, disclosureIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            assetLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            assetLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            assetValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            assetValueLabel.leadingAnchor.constraint(equalTo: assetLabel.trailingAnchor, constant: 8),
            
            disclosureIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
