import UIKit
import ProgressHUD

final class CartViewController: UIViewController {

  private let viewModel = CartViewModel()

  let servicesAssembly: ServicesAssembly

  init(servicesAssembly: ServicesAssembly) {
    self.servicesAssembly = servicesAssembly
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupAppearance()
    viewModel.onItemsUpdated = {
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.updateSummary()
        self.updateHolders()
      }
    }
    viewModel.loadItems()
    viewModel.applySorting()
  }

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = 140
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .systemBackground
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartCell")
    return tableView
  }()

  private lazy var placeholderLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.bodyBold
    label.text = Strings.Cart.emptyMsg
    label.textColor = UIColor.segmentActive
    label.isHidden = true
    return label
  }()

  private lazy var sortButton: UIButton = {
    let sortButton = UIButton()
    let image = Images.Common.sortBtn?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal)
    sortButton.setImage(image, for: .normal)
    sortButton.addTarget(nil, action: #selector(sortButtonTapped), for: .touchUpInside)
    return sortButton
  }()

  private lazy var payButton: UIButton = {
    let payButton = UIButton()
    payButton.setTitle(Strings.Cart.toPay, for: .normal)
    payButton.setTitleColor(UIColor.textButton, for: .normal)
    payButton.titleLabel?.font = UIFont.bodyBold
    payButton.layer.cornerRadius = 16
    payButton.layer.masksToBounds = true
    payButton.backgroundColor = UIColor.segmentActive
    payButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
    payButton.translatesAutoresizingMaskIntoConstraints = false
    return payButton
  }()

  private lazy var quantityNFTLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.caption1
    label.textColor = UIColor.segmentActive
    label.text = "0 NFT"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var totalAmountLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.bodyBold
    label.text = "0 \(Strings.Common.eth)"
    label.textColor = UIColor.currencyType
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var backgroundView: UIView = {
    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor.segmentInactive
    backgroundView.layer.masksToBounds = true
    backgroundView.layer.cornerRadius = 12
    backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    backgroundView.addSubview(totalAmountLabel)
    backgroundView.addSubview(quantityNFTLabel)
    backgroundView.addSubview(payButton)

    NSLayoutConstraint.activate([
      quantityNFTLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
      quantityNFTLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),

      totalAmountLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
      totalAmountLabel.topAnchor.constraint(equalTo: quantityNFTLabel.bottomAnchor, constant: 8),

      payButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
      payButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
      payButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
      payButton.heightAnchor.constraint(equalToConstant: 50),
      payButton.widthAnchor.constraint(equalToConstant: 240)
    ])
    return backgroundView
  }()

  @objc private func paymentButtonTapped() {
    let paymentViewController = PaymentViewController()
    navigationController?.pushViewController(paymentViewController, animated: true)
    navigationController?.navigationBar.tintColor = UIColor.segmentActive
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }

  @objc private func sortButtonTapped() {
    let actionSheet = UIAlertController(title: Strings.Alerts.sortTitle, message: nil, preferredStyle: .actionSheet)

    let priceSort = UIAlertAction(title: Strings.Alerts.sortByPrice, style: .default) { _ in
      self.viewModel.sortByPrice()
      self.tableView.reloadData()
    }

    let ratingSort = UIAlertAction(title: Strings.Alerts.sortByRating, style: .default) { _ in
      self.viewModel.sortByRating()
      self.tableView.reloadData()
    }

    let titleSort = UIAlertAction(title: Strings.Alerts.sortByName, style: .default) { _ in
      self.viewModel.sortByName()
      self.tableView.reloadData()
    }

    let cancelAction = UIAlertAction(title: Strings.Alerts.closeBtn, style: .cancel)

    [priceSort, ratingSort, titleSort, cancelAction].forEach { actionSheet.addAction($0) }
    present(actionSheet, animated: true, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  func setupAppearance() {
    [tableView, sortButton, placeholderLabel, backgroundView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0) }

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor),

      sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
      sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
      sortButton.widthAnchor.constraint(equalToConstant: 42),
      sortButton.heightAnchor.constraint(equalToConstant: 42),

      placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundView.heightAnchor.constraint(equalToConstant: 76)
    ])
  }

  private func updateSummary() {
    let totalAmount = viewModel.totalAmount()
    let totalQuantity = viewModel.totalQuantity()

    quantityNFTLabel.text = "\(totalQuantity) NFT"
    totalAmountLabel.text = "\(totalAmount) \(Strings.Common.eth)"
  }

  private func updateHolders() {
    tableView.isHidden = viewModel.nftItems.isEmpty
    payButton.isHidden = viewModel.nftItems.isEmpty
    backgroundView.isHidden = viewModel.nftItems.isEmpty
    sortButton.isHidden = viewModel.nftItems.isEmpty
    placeholderLabel.isHidden = !viewModel.nftItems.isEmpty
  }
}

extension CartViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.nftItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartTableViewCell else {
      return UITableViewCell()
    }
    let item = viewModel.nftItems[indexPath.row]
    cell.configure(with: item)
    return cell
  }
}

extension CartViewController: UITableViewDelegate {
  // TODO:
}

extension CartViewController: DeleteViewControllerDelegate {
    func didConfirmDeletion(of nftItem: Nft) {
        guard let index = viewModel.nftItems.firstIndex(where: { $0.name == nftItem.name }) else { return }
        viewModel.removeItem(at: index)
    }
}
