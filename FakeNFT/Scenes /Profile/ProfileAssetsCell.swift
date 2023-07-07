import UIKit

final class ProfileAssetsCell: UITableViewCell, ReuseIdentifying {
    
    //MARK: - Layout elements
    private lazy var assetLabel: UILabel = {
        var assetLabel = UILabel()
        assetLabel.translatesAutoresizingMaskIntoConstraints = false
        assetLabel.font = .boldSystemFont(ofSize: 17)
        assetLabel.textColor = .black
        return assetLabel
    }()
    
    private lazy var assetValue: UILabel = {
        var assetValue = UILabel()
        assetValue.translatesAutoresizingMaskIntoConstraints = false
        assetValue.font = .boldSystemFont(ofSize: 17)
        assetValue.textColor = .black
        return assetValue
    }()
    
    private lazy var disclosureIndicator: UIImageView = {
        var disclosureIndicator = UIImageView()
        disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        disclosureIndicator.image = UIImage(systemName: "chevron.forward")
        disclosureIndicator.tintColor = .black
        disclosureIndicator.preferredSymbolConfiguration = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 17))
        return disclosureIndicator
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAssetLabel()
        addAssetValue()
        addDisclosureIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setAssets(label: String?, value: String?) {
        if let label = label { assetLabel.text = label }
        if let value = value { assetValue.text = value }
    }
    
    // MARK: - Layout methods
    private func addAssetLabel() {
        addSubview(assetLabel)
        NSLayoutConstraint.activate([
            assetLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            assetLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
    }
    
    private func addAssetValue() {
        addSubview(assetValue)
        NSLayoutConstraint.activate([
            assetValue.centerYAnchor.constraint(equalTo: centerYAnchor),
            assetValue.leadingAnchor.constraint(equalTo: assetLabel.trailingAnchor, constant: 8)
        ])
    }
    
    private func addDisclosureIndicator() {
        addSubview(disclosureIndicator)
        NSLayoutConstraint.activate([
            disclosureIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
