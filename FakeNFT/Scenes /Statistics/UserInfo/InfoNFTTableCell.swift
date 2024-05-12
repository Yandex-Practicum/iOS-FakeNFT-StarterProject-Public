import UIKit

final class InfoNFTTableCell: UITableViewCell, ReuseIdentifying {
    
    static let defaultReuseIdentifier = "infoNFTCell"
    
    //MARK: - UI elements
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textColor
        label.text = NSLocalizedString("UserInfo.nftCollections", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countsNFTLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "forward") ?? UIImage(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    //MARK: - Layout
    
    private func setupViews(){
        backgroundColor = .systemBackground
        
        contentView.addSubview(infoLabel)
        contentView.addSubview(countsNFTLabel)
        contentView.addSubview(forwardButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            countsNFTLabel.leadingAnchor.constraint(equalTo: infoLabel.trailingAnchor, constant: 8),
            countsNFTLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            forwardButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            forwardButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    //MARK: - Functions
    
    func configure(with countNFT: Int) {
        countsNFTLabel.text = "(\(countNFT))"
    }
}

