import UIKit

final class CurrencyScreenViewController: UIViewController, LoadingView {
    private var viewModel: CurrencyViewModelProtocol
    private var selectedCurrencyIndex: IndexPath?

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .backward).withTintColor(UIColor(resource: .blackDayNight))
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(resource: .blackDayNight)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var currencyCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        return layout
    }()

    private lazy var currencyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: currencyCollectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CurrencyCollectionViewCell.self,
                                forCellWithReuseIdentifier: CurrencyCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var agreementLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = UIColor(resource: .blackDayNight)
        label.numberOfLines = 0
        label.text = L10n.Currency.cartUserAgreementText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var agreementLinkButton: UIButton = {
       let button = UIButton()
        button.setTitle(L10n.Currency.cartUserAgreementLinkText, for: .normal)
        button.titleLabel?.font = .caption2
        button.setTitleColor(UIColor(resource: .blue), for: .normal)
        button.addTarget(self, action: #selector(tapUserAgreementLink), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var userAgreementStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.addArrangedSubview(agreementLabel)
        stackView.addArrangedSubview(agreementLinkButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var paymentButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle(L10n.Currency.paymentConfirmButtonText, for: .normal)
        button.setTitleColor(UIColor(resource: .whiteDayNight), for: .normal)
        button.titleLabel?.font = .bodyBold
        button.backgroundColor = UIColor(resource: .blackDayNight)
        button.addTarget(self, action: #selector(tapPayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var paymentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.addArrangedSubview(userAgreementStackView)
        stackView.addArrangedSubview(paymentButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var paymentContainView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(resource: .lightDayNight)
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: CurrencyViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteDayNight)
        createSubviews()
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.hideLoading()
                self?.currencyCollectionView.reloadData()
            }
        }
        viewModel.onSuccessResult = { [weak self] in
            DispatchQueue.main.async {
                self?.showSuccessResult()
            }
        }
        viewModel.onErrorResult = { [weak self] in
            DispatchQueue.main.async {
                self?.showErrorResult()
            }
        }
        viewModel.onDataErrorResult = { [weak self] in
            self?.showLoadDataError()
        }
        showLoading()
        viewModel.loadData()
    }

    private func showErrorResult() {
        AlertPresenter.showPaymentError(on: self) { [weak self] in
            self?.viewModel.getPaymentResult(with: self?.viewModel.selectedCurrencyID ?? "")
        }
    }

    private func showSuccessResult() {
        let paymentViewController = PaymentSuccessViewController()
        let navigationController = UINavigationController(rootViewController: paymentViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hidesBottomBarWhenPushed = true
        present(navigationController, animated: true)
    }

    private func showLoadDataError() {
        AlertPresenter.showDataError(on: self) { [weak self] in
            self?.viewModel.loadData()
        }
    }

    @objc
    private func tapBackButton() {
        dismiss(animated: true)
    }

    @objc
    private func tapUserAgreementLink() {
        let viewModel = WebViewViewModel()
        let url = URL(string: RequestConstants.cartUserAgreementLink)
        let view = WebViewController(viewModel: viewModel ,url: url)
        navigationController?.pushViewController(view, animated: true)
    }

    @objc
    private func tapPayButton() {
        guard let selectedCurrencyID = viewModel.selectedCurrencyID else {
            AlertPresenter.showError(on: self)
            return
        }
        viewModel.getPaymentResult(with: selectedCurrencyID)
    }
}

extension CurrencyScreenViewController {
    private func createSubviews() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButton)]
        navigationItem.title = L10n.Currency.paymentTypeText
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.bodyBold,
            .foregroundColor: UIColor(resource: .blackDayNight)
        ]
        addCurrencyCollectionView()
        addPaymentContainView()
        addAgreementStackView()
    }

    private func addCurrencyCollectionView() {
        view.addSubview(currencyCollectionView)
        NSLayoutConstraint.activate([
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currencyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
            ])
    }

    private func addPaymentContainView() {
        view.addSubview(paymentContainView)
        NSLayoutConstraint.activate([
            paymentContainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentContainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentContainView.topAnchor.constraint(equalTo: currencyCollectionView.bottomAnchor),
            paymentContainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    private func addAgreementStackView() {
        paymentContainView.addSubview(paymentStackView)
        NSLayoutConstraint.activate([
            paymentStackView.leadingAnchor.constraint(equalTo: paymentContainView.leadingAnchor, constant: 16),
            paymentStackView.trailingAnchor.constraint(equalTo: paymentContainView.trailingAnchor, constant: -16),
            paymentStackView.topAnchor.constraint(equalTo: paymentContainView.topAnchor, constant: 16),
            paymentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
}

extension CurrencyScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyCollectionViewCell.reuseIdentifier,
            for: indexPath) as? CurrencyCollectionViewCell else { return }
        cell.isSelected = true
        if let selectedCurrencyIndex, selectedCurrencyIndex != indexPath {
            let cell = collectionView.cellForItem(at: selectedCurrencyIndex) as? CurrencyCollectionViewCell
            cell?.isSelected = false
        }
        viewModel.selectCurrency(at: indexPath)
    }
}

extension CurrencyScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.currencies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyCollectionViewCell.reuseIdentifier,
            for: indexPath) as? CurrencyCollectionViewCell else {
            return UICollectionViewCell()
        }
        let currency = viewModel.currencies[indexPath.row]
        cell.configure(with: currency)
        return cell
    }
}

extension CurrencyScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 7) / 2
        return CGSize(width: width, height: 46)
    }
}
