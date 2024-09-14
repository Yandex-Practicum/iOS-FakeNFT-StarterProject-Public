import UIKit

final class PaymentResultViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
  }

  private lazy var backToCatalogButton: UIButton = {
    let backToCatalogButton = UIButton()
    backToCatalogButton.setTitle(Strings.Cart.payBtn, for: .normal)
    backToCatalogButton.setTitleColor(UIColor.textButton, for: .normal)
    backToCatalogButton.titleLabel?.font = UIFont.bodyBold
    backToCatalogButton.layer.cornerRadius = 16
    backToCatalogButton.layer.masksToBounds = true
    backToCatalogButton.backgroundColor = UIColor.segmentActive
    backToCatalogButton.addTarget(self, action: #selector(backToCatalog), for: .touchUpInside)
    backToCatalogButton.translatesAutoresizingMaskIntoConstraints = false
    return backToCatalogButton
  }()

  private lazy var succesLabel: UILabel = {
    let succesLabel = UILabel()
    succesLabel.font = UIFont.bodyBold
    succesLabel.text = Strings.Cart.emptyMsg
    succesLabel.textColor = UIColor.segmentActive
    succesLabel.isHidden = true
    return succesLabel
  }()

  private lazy var holderImage: UIImageView = {
    let holderImage = UIImageView()
    holderImage.image = UIImage(named: "paymentHolder")
    holderImage.contentMode = .scaleAspectFit
    return holderImage
  }()

  private lazy var stack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [holderImage, succesLabel])
    stack.axis = .vertical
    stack.spacing = 0
    stack.alignment = .leading
    return stack
  }()

  @objc private func backToCatalog() {
    //TODO: add transition to the catalog tab
  }

  func setupAppearance() {

  }
}
