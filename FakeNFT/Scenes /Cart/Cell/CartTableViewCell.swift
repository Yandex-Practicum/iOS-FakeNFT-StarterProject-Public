import UIKit

final class CartTableViewCell: UITableViewCell {

  private var nftItem: NftItem?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private lazy var nftImage: UIImageView = {
    let nftImage = UIImageView()
    nftImage.layer.cornerRadius = 12
    nftImage.layer.masksToBounds = true
    return nftImage
  }()

  private lazy var nftLabel: UILabel = {
    let nftLabel = UILabel()
    nftLabel.font = UIFont.bodyBold
    return nftLabel
  }()

  private lazy var nftRatingView: UIStackView = {
    let nftRatingView = UIStackView()
    nftRatingView.axis = .horizontal
    nftRatingView.spacing = 4
    return nftRatingView
  }()

  private lazy var nftPriceLabel: UILabel = {
    let nftPriceLabel = UILabel()
    nftPriceLabel.font = UIFont.caption2
    nftPriceLabel.text = "\(Strings.Common.price)"
    return nftPriceLabel
  }()

  private lazy var nftPrice: UILabel = {
    let nftPrice = UILabel()
    nftPrice.font = UIFont.bodyBold
    return nftPrice
  }()

  private lazy var removeButton: UIButton = {
    let removeButton = UIButton()
    let image = Images.Common.deleteCartBtn?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal)
    removeButton.setImage(image, for: .normal)
    removeButton.addTarget(self, action: #selector(deleteNft), for: .touchUpInside)
    return removeButton
  }()

  func setupAppearance() {
    [nftImage, nftLabel, nftRatingView, nftPriceLabel, nftPrice, removeButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0) }

    NSLayoutConstraint.activate([
      nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nftImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      nftImage.widthAnchor.constraint(equalToConstant: 108),
      nftImage.heightAnchor.constraint(equalToConstant: 108),

      nftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
      nftLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),

      nftRatingView.topAnchor.constraint(equalTo: nftLabel.bottomAnchor, constant: 4),
      nftRatingView.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),

      nftPriceLabel.topAnchor.constraint(equalTo: nftRatingView.bottomAnchor, constant: 12),
      nftPriceLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),

      nftPrice.topAnchor.constraint(equalTo: nftPriceLabel.bottomAnchor, constant: 2),
      nftPrice.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),

      removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      removeButton.widthAnchor.constraint(equalToConstant: 40),
      removeButton.heightAnchor.constraint(equalToConstant: 40),
    ])
  }

  func configure(with nftItem: NftItem) {
    self.nftItem = nftItem
    nftImage.image = nftItem.image
    nftLabel.text = nftItem.name
    nftPrice.text = "\(nftItem.price) \(Strings.Common.eth)"
    configureRating(rating: nftItem.rating)
  }

  
  @objc private func deleteNft() {
    guard let parentViewController = self.parentViewController, let nftItem = nftItem else { return }
    let deleteViewController = DeleteViewController(nftItem: nftItem)
    deleteViewController.modalPresentationStyle = .overFullScreen
    deleteViewController.delegate = parentViewController as? CartViewController
    parentViewController.present(deleteViewController, animated: true)
  }

  private func configureRating(rating: Int) {
    nftRatingView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    for index in 1...5 {
      let starImageView = UIImageView()
      starImageView.image = index <= rating ? Images.Common.starActive : Images.Common.startInactive
      starImageView.tintColor = .yellow
      starImageView.translatesAutoresizingMaskIntoConstraints = false
      starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
      starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
      nftRatingView.addArrangedSubview(starImageView)
    }
  }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
