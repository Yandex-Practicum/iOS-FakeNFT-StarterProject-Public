import UIKit
import Kingfisher

protocol DeleteViewControllerDelegate: AnyObject {
  
  func didConfirmDeletion(of nftItem: Nft)
}

final class DeleteViewController: UIViewController {
  
  private var nftItem: Nft
  weak var delegate: DeleteViewControllerDelegate?
  
  init(nftItem: Nft) {
    self.nftItem = nftItem
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var nftImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 12
    imageView.layer.masksToBounds = true
    imageView.kf.indicatorType = .activity
    if let firstImageUrl = nftItem.images.first {
      imageView.kf.setImage(
            with: firstImageUrl,
            placeholder: UIImage(named: "mockNFT"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
    } else {
      imageView.image = UIImage(named: "mockNFT")
    }
    return imageView
  }()
  
  private lazy var confirmationLabel: UILabel = {
    let label = UILabel()
    label.text = Strings.Cart.deleteMessage
    label.font = UIFont.caption2
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle(Strings.Cart.deleteBrn, for: .normal)
    button.setTitleColor(UIColor.deleteButton, for: .normal)
    button.backgroundColor = UIColor.segmentActive
    button.layer.cornerRadius = 16
    button.addTarget(self, action: #selector(deleteNft), for: .touchUpInside)
    return button
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle(Strings.Cart.cancleBtn, for: .normal)
    button.setTitleColor(UIColor.textButton, for: .normal)
    button.backgroundColor = UIColor.segmentActive
    button.layer.cornerRadius = 16
    button.addTarget(self, action: #selector(cancelDeletion), for: .touchUpInside)
    return button
  }()

  private lazy var buttonStack: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [deleteButton, cancelButton])
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.distribution = .fillEqually
    return stackView
  }()

  private lazy var mainStack: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [nftImageView, confirmationLabel, buttonStack])
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.spacing = 15
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    setupBlurEffect()
  }
  
  private func setupAppearance() {
    view.backgroundColor = UIColor.clear

    confirmationLabel.textAlignment = .center

    [nftImageView, mainStack, buttonStack].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0) }

    NSLayoutConstraint.activate([
      mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
      mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
      mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),

      buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      buttonStack.heightAnchor.constraint(equalToConstant: 44),
      buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
      buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),

      nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      nftImageView.widthAnchor.constraint(equalToConstant: 108),
      nftImageView.heightAnchor.constraint(equalToConstant: 108)

    ])
  }
  
  private func setupBlurEffect() {
    let blurEffect = UIBlurEffect(style: .regular)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.insertSubview(blurEffectView, at: 0)
  }
  
  @objc private func deleteNft() {
    delegate?.didConfirmDeletion(of: nftItem)
    dismiss(animated: true)
  }
  
  @objc private func cancelDeletion() {
    dismiss(animated: true)
  }
}
