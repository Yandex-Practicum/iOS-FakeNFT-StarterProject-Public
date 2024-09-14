import UIKit

final class PaymentViewController: UIViewController {

  let servicesAssembly: ServicesAssembly

  init(servicesAssembly: ServicesAssembly) {
    self.servicesAssembly = servicesAssembly
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private var isLoading = false
  private var currencies : [Currency] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  override func viewDidLoad() {
    view.backgroundColor = .systemBackground
    super.viewDidLoad()
    setupAppearance()
  }

  private lazy var payButton: UIButton = {
    let payButton = UIButton()
    payButton.setTitle(Strings.Cart.payBtn, for: .normal)
    payButton.setTitleColor(UIColor.textButton, for: .normal)
    payButton.titleLabel?.font = UIFont.bodyBold
    payButton.layer.cornerRadius = 16
    payButton.layer.masksToBounds = true
    payButton.backgroundColor = UIColor.segmentActive
    payButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
    payButton.translatesAutoresizingMaskIntoConstraints = false
    return payButton
  }()

  private lazy var agreementLabel: UILabel = {
    let agreementLabel = UILabel()
    agreementLabel.font = UIFont.caption2
    agreementLabel.text = Strings.Cart.userAgreementMsg
    agreementLabel.textColor = UIColor.textPrimary
    return agreementLabel
  }()

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    collectionView.allowsMultipleSelection = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.showsVerticalScrollIndicator = false
    collectionView.register(PaymentViewCell.self, forCellWithReuseIdentifier: "cell")
    return collectionView
  }()

  private let agreementButton: UIButton = {
    let agreementButton = UIButton()
    agreementButton.setTitle(Strings.Cart.userAgreement, for: .normal)
    agreementButton.setTitleColor(UIColor.link, for: .normal)
    agreementButton.titleLabel?.font = .systemFont(ofSize: 13)
    agreementButton.addTarget(PaymentViewController.self, action: #selector(showAgreement), for: .touchUpInside)
    return agreementButton
  }()

  private lazy var stack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [agreementLabel, agreementButton])
    stack.axis = .vertical
    stack.spacing = 0
    stack.alignment = .leading
    return stack
  }()

  private lazy var backgroundView: UIView = {
    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor.segmentInactive
    backgroundView.layer.masksToBounds = true
    backgroundView.layer.cornerRadius = 12
    backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    backgroundView.addSubview(agreementLabel)
    backgroundView.addSubview(agreementButton)

    NSLayoutConstraint.activate([
      agreementLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
      agreementLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),

      agreementButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
      agreementButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: 4),
    ])
    return backgroundView
  }()

  func setupAppearance() {
    title = Strings.Cart.navTitle
    view.backgroundColor = .systemBackground
    tabBarController?.tabBar.isHidden = true

    [collectionView, stack, backgroundView, payButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0) }

    NSLayoutConstraint.activate([
      collectionView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

      stack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundView.heightAnchor.constraint(equalToConstant: 186),

      payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      payButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 740),
      payButton.heightAnchor.constraint(equalToConstant: 60),
    ])
  }

  @objc private func paymentButtonTapped() {
    let paymentResult = PaymentResultViewController()
    navigationController?.pushViewController(paymentResult, animated: true)
  }

  @objc private func showAgreement() {
    let webViewController = WebViewController()
    navigationController?.pushViewController(webViewController, animated: true)
    navigationController?.navigationBar.tintColor = UIColor.segmentActive
  }
}

extension PaymentViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    currencies.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PaymentViewCell else { return UICollectionViewCell() }
    let currency = currencies[indexPath.item]
//    cell.configureCell(currency: currency)
    cell.backgroundColor = UIColor.segmentInactive
    cell.layer.cornerRadius = 12
    return cell
  }
}

extension PaymentViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as? PaymentViewCell
    cell?.layer.borderWidth = 1
    cell?.layer.cornerRadius = 12
    cell?.layer.borderColor = UIColor.segmentActive.cgColor
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as? PaymentViewCell
    cell?.layer.borderWidth = 0
  }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemCount : CGFloat = 2
    let space: CGFloat = 7
    let width : CGFloat = (collectionView.bounds.width - space - 32) / itemCount
    let height : CGFloat = 46
    return CGSize(width: width , height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 7
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 7
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
  }
}
