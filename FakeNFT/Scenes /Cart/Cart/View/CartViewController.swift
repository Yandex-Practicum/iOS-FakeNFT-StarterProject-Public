import UIKit

final class CartViewController: UIViewController, LoadingView {
    private let viewModel: CartViewModel
    private var deleteNftIndex: Int = 0

    private lazy var filterButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "sort_button")?.withTintColor(UIColor.nftBlack)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tapFilterButton), for: .touchUpInside)
        return button
    }()

    private lazy var cartTableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var countNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "0 NFT"
        label.textColor = UIColor.nftBlack
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ETH"
        label.textColor = UIColor.nftGreenUniversal
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var paymentInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.addArrangedSubview(countNFTLabel)
        stackView.addArrangedSubview(totalPriceLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle(L10n.Cart.buttonText, for: .normal)
        button.setTitleColor(UIColor.nftWhite, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.backgroundColor = UIColor.nftBlack
        button.addTarget(self, action: #selector(tapPayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var paymentContainView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.nftLightgrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Cart.emptyCart
        label.textColor = UIColor.nftBlack
        label.font = .bodyBold
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var confirmDeleteLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Cart.deleteConfirmText
        label.textColor = UIColor.nftBlack
        label.font = .caption2
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var deleteNftButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle(L10n.Cart.deleteButtonText, for: .normal)
        button.setTitleColor(UIColor.nftRedUniversal, for: .normal)
        button.titleLabel?.font = .bodyRegular
        button.backgroundColor = UIColor.nftBlack
        button.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle(L10n.Cart.backButtonText, for: .normal)
        button.setTitleColor(UIColor.nftWhite, for: .normal)
        button.titleLabel?.font = .bodyRegular
        button.backgroundColor = UIColor.nftBlack
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.addArrangedSubview(deleteNftButton)
        stackView.addArrangedSubview(cancelButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var backgroundBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.effect = UIBlurEffect(style: .regular)
        view.frame = UIScreen.main.bounds
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        observeViewModelChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.nftWhite
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        createSubviews()
        viewModel.loadData()
        showLoading()
        viewModel.onDataErrorResult = { [weak self] in
            self?.showLoadDataError()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if PurchaseCartStorage.shared.nfts.count != viewModel.nfts.count {
            viewModel.loadData()
            showLoading()
            viewModel.onDataErrorResult = { [weak self] in
                self?.showLoadDataError()
            }
        }
    }

    private func observeViewModelChanges() {
        viewModel.$nfts.bind { [weak self] nfts in
            guard let self else { return }
            self.updateUI(with: nfts)
        }
    }

    private func updateUI(with nfts: [Nft]) {
        cartTableView.reloadData()
        countNFTLabel.text = "\(viewModel.countNftInCart()) NFT"
        totalPriceLabel.text = "\(viewModel.getTotalPrice()) ETH"
        hideLoading()
        checkPlaceholder()
    }

    private func checkPlaceholder() {
        if viewModel.nfts.isEmpty {
            paymentContainView.isHidden = true
            filterButton.isHidden = true
            cartTableView.isHidden = true
            emptyCartLabel.isHidden = false
        } else {
            paymentContainView.isHidden = false
            filterButton.isHidden = false
            cartTableView.isHidden = false
            emptyCartLabel.isHidden = true
        }
    }

    private func showFiltersAlert() {
        AlertPresenter.showCartFiltersAlert(on: self, viewModel: viewModel)
    }

    private func showLoadDataError() {
        AlertPresenter.showDataError(on: self) { [weak self] in
            self?.showLoading()
            self?.viewModel.loadData()
        }
    }

    @objc
    private func tapFilterButton() {
        showFiltersAlert()
    }

    @objc
    private func tapPayButton() {
        let moduleFactory = ModuleFactory(servicesAssembly: viewModel.servicesAssembly)
        let currencyModule = moduleFactory.makeCurrencyModule()
        present(currencyModule, animated: true)
    }

    @objc
    private func tapDeleteButton() {
        viewModel.deleteNftFromCart(at: deleteNftIndex)
        hideBackroundBlurView()
    }

    @objc
    private func tapBackButton() {
        hideBackroundBlurView()
    }
}

extension CartViewController {
    private func createSubviews() {
        addCartTableView()
        addPaymentContainView()
        addPaymentInfoStackView()
        addPayButton()
        addEmptyCartLabel()
    }

    private func addCartTableView() {
        view.addSubview(cartTableView)
        NSLayoutConstraint.activate([
            cartTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }

    private func addPaymentContainView() {
        view.addSubview(paymentContainView)
        NSLayoutConstraint.activate([
            paymentContainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            paymentContainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            paymentContainView.topAnchor.constraint(equalTo: cartTableView.bottomAnchor),
            paymentContainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentContainView.heightAnchor.constraint(equalToConstant: 76)
        ])
    }

    private func addPaymentInfoStackView() {
        paymentContainView.addSubview(paymentInfoStackView)
        NSLayoutConstraint.activate([
            paymentInfoStackView.leadingAnchor.constraint(equalTo: paymentContainView.leadingAnchor, constant: 16),
            paymentInfoStackView.centerYAnchor.constraint(equalTo: paymentContainView.centerYAnchor)
        ])
    }

    private func addPayButton() {
        paymentContainView.addSubview(paymentButton)
        NSLayoutConstraint.activate([
            paymentButton.leadingAnchor.constraint(equalTo: paymentInfoStackView.trailingAnchor, constant: 24),
            paymentButton.trailingAnchor.constraint(equalTo: paymentContainView.trailingAnchor, constant: -16),
            paymentButton.centerYAnchor.constraint(equalTo: paymentContainView.centerYAnchor),
            paymentButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func addEmptyCartLabel() {
        view.addSubview(emptyCartLabel)
        NSLayoutConstraint.activate([
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

extension CartViewController: CartCellDelegate {
    func didTapDeleteNft(at index: Int) {
        backgroundBlurView.isHidden = false
        nftImageView.kf.setImage(with: viewModel.getNft(at: index).images.first)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        deleteNftIndex = index
        createDeleteView()
    }

    private func createDeleteView() {
        addBackgroundBlurView()
        addNftImageView()
        addConfirmDeleteLabel()
        addButtonsStackView()
    }

    private func hideBackroundBlurView() {
        backgroundBlurView.removeFromSuperview()
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    private func addBackgroundBlurView() {
        view.addSubview(backgroundBlurView)
        NSLayoutConstraint.activate([
            backgroundBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundBlurView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    private func addNftImageView() {
        backgroundBlurView.contentView.addSubview(nftImageView)
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)
            ])
    }

    private func addConfirmDeleteLabel() {
        backgroundBlurView.contentView.addSubview(confirmDeleteLabel)
        NSLayoutConstraint.activate([
            confirmDeleteLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            confirmDeleteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmDeleteLabel.widthAnchor.constraint(equalToConstant: 180)
            ])
    }

    private func addButtonsStackView() {
        backgroundBlurView.contentView.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: confirmDeleteLabel.bottomAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: backgroundBlurView.leadingAnchor, constant: 56),
            buttonsStackView.trailingAnchor.constraint(equalTo: backgroundBlurView.trailingAnchor, constant: -56),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier)
                as? CartTableViewCell else {
            return UITableViewCell()
        }
        let nft = viewModel.getNft(at: indexPath.row)
        cell.configure(with: nft)
        cell.delegate = self
        cell.cellIndex = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countNftInCart()
    }
}
