import UIKit

final class MyNFTCell: UITableViewCell, ReuseIdentifying {
    // MARK: - Private properties
    private lazy var imageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var aboutNFCStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private lazy var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        return nftImage
    }()
    
    private lazy var favoriteNFTButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegular
        label.textColor = .black
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .black
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = NSLocalizedString("nft.price", comment: "")
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "0 ETH"
        return label
    }()
    
    // MARK: - Private methods
    private func addingUIElements() {
        [imageStack, aboutNFCStack, priceStack].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        [nftImage, favoriteNFTButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            imageStack.addSubview($0)
        }
        [nftNameLabel, ratingStack, authorLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            aboutNFCStack.addSubview($0)
        }
        [priceLabel, priceValueLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            priceStack.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
        ])
    }
}
