import UIKit
import SnapKit
import Kingfisher

final class CartItemCell: UITableViewCell {
    
    static let reuseIdentifier = "CartItemCell"
    
    // MARK: - UI Elements
    
    let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive
        
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.caption1
        label.textColor = UIColor.segmentActive
        label.text = NSLocalizedString("CartItem.price", comment: "")
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive
        
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(resource: .deleteFromCart),
                                           target: nil,
                                           action: nil)
        button.tintColor = UIColor.segmentActive
        
        return button
    }()
    
    // MARK: - Layout Stacks
    
    private var infoVStack = UIStackView()
    private var ratingHStack = UIStackView()
    private var titleAndStarsVStack = UIStackView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(nftImageView)
        contentView.addSubview(deleteButton)
        
        setupImage()
        setupNftInfo()
        setupDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
         )
      )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ratingHStack.removeFromSuperview()
    }
    
    // MARK: - Public Methods
    
    func configure(with model: CartItemModel) {
        ratingHStack = getRatingHStack(model.rating)
        titleAndStarsVStack.addArrangedSubview(ratingHStack)
        
        changeImage(model.image)
        setPrice(model.price)
        setTitle(model.title)
    }
    
    // MARK: - Private Methods
    
    private func changeImage(_ url: URL) {
        nftImageView.kf.setImage(with: url)
    }
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setPrice(_ price: Double) {
        priceTitleLabel.text = "\(price) ETH"
    }
    
    private func setupImage() {
        nftImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges)
            make.size.equalTo(nftImageView.snp.height)
        }
    }
    
    private func setupNftInfo() {
        titleAndStarsVStack = UIStackView (arrangedSubviews: [titleLabel])
        
        let priceVStack = UIStackView(arrangedSubviews: [priceTitleLabel, priceLabel])
        let infoVStack = UIStackView(arrangedSubviews: [titleAndStarsVStack, priceVStack])
        
        [infoVStack,
         titleAndStarsVStack,
         priceVStack].forEach{
            $0.axis = .vertical
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.alignment = .leading
        }
        
        titleAndStarsVStack.spacing = 4
        priceVStack.spacing = 2
        infoVStack.spacing = 12
        
        self.infoVStack = infoVStack
        contentView.addSubview(self.infoVStack)
        self.infoVStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
            make.leading.equalTo(nftImageView.snp.trailing).offset(20)
        }
    }
    
    private func setupDeleteButton() {
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    private func getRatingHStack(_ rating: Int) -> UIStackView {
        var stars = [UIImageView]()
        for starIndex in 0..<5 {
            let fillStarImageView = UIImageView(image: UIImage(resource: .starDone))
            let emptyStarImageView = UIImageView(image: UIImage(resource: .starNoActive))
            stars.append((rating - 1) >= starIndex ? fillStarImageView : emptyStarImageView)
        }
        
        let hStack = UIStackView(arrangedSubviews: stars)
        hStack.axis = .horizontal
        hStack.spacing = 2
        
        return hStack
    }
}
