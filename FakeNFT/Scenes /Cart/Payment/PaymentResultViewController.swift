import UIKit

final class PaymentResultViewController: UIViewController {

  override func viewDidLoad() {
    view.backgroundColor = .systemBackground
    super.viewDidLoad()
    setupAppearance()
  }

  private lazy var backToCatalogButton: UIButton = {
    let backToCatalogButton = UIButton()
    backToCatalogButton.setTitle(Strings.Cart.backToCartBtn, for: .normal)
    backToCatalogButton.setTitleColor(UIColor.textButton, for: .normal)
    backToCatalogButton.titleLabel?.font = UIFont.bodyBold
    backToCatalogButton.layer.cornerRadius = 16
    backToCatalogButton.layer.masksToBounds = true
    backToCatalogButton.backgroundColor = UIColor.closeButton
    backToCatalogButton.addTarget(self, action: #selector(backToCatalog), for: .touchUpInside)
    backToCatalogButton.translatesAutoresizingMaskIntoConstraints = false
    return backToCatalogButton
  }()

  private lazy var succesLabel: UILabel = {
    let succesLabel = UILabel()
    succesLabel.font = UIFont.bodyBold
    succesLabel.text = Strings.Cart.successMsg
    succesLabel.textColor = UIColor.textPrimary
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
    succesLabel.numberOfLines = 2
    succesLabel.textAlignment = .center

    navigationController?.setNavigationBarHidden(true, animated: true)

    [stack, backToCatalogButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0) }

    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),

      holderImage.heightAnchor.constraint(equalToConstant: 278),
      holderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      holderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      backToCatalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      backToCatalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      backToCatalogButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 740),
      backToCatalogButton.heightAnchor.constraint(equalToConstant: 60),
      ])
  }
}
