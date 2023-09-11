import UIKit

final class PaymentChoiceViewController: UIViewController {
    
    var viewModel: PaymentViewModelProtocol
    
    init(viewModel: PaymentViewModelProtocol = PaymentViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedMethodPayCell: IndexPath? = nil
    
    private var selectedMethodPay: CurrencyModel? = nil {
        didSet {
            updatePaymentButton()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Выберите способ оплаты"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return titleLabel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PaymentChoiceCell.self, forCellWithReuseIdentifier: PaymentChoiceCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var returnButton: UIButton = {
        let returnButton = UIButton()
        returnButton.setImage(UIImage(named: "returnButton"), for: .normal)
        returnButton.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
        return returnButton
    }()
    
    private lazy var buttonPaymentView: UIView = {
        let buttonPaymentView = UIView()
        buttonPaymentView.backgroundColor = .ypLightGrey
        buttonPaymentView.layer.cornerRadius = 12
        buttonPaymentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return buttonPaymentView
    }()
    
    private lazy var firstLabel: UILabel = {
        let firstLabel = UILabel()
        firstLabel.text = "Совершая покупку, вы соглашаетесь с условиями"
        firstLabel.font = UIFont.systemFont(ofSize: 13)
        return firstLabel
    }()
    
    private lazy var termOfUseLabel: UILabel = {
        let termOfUseLabel = UILabel()
        termOfUseLabel.text = "Пользовательского соглашения"
        termOfUseLabel.font = UIFont.systemFont(ofSize: 13)
        termOfUseLabel.textColor = .ypBlue
        termOfUseLabel.isUserInteractionEnabled = true
        termOfUseLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTermOfUseLabel)))
        return termOfUseLabel
    }()
    
    private lazy var paymentButton: UIButton = {
        let paymentButton = UIButton()
        paymentButton.backgroundColor = .gray
        paymentButton.isEnabled = false
        paymentButton.layer.cornerRadius = 16
        paymentButton.setTitleColor(.white, for: .normal)
        paymentButton.setTitle("Оплатить", for: .normal)
        paymentButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        paymentButton.addTarget(self, action: #selector(didTapPaymentButton), for: .touchUpInside)
        return paymentButton
    }()
    
    private func addView() {
        [titleLabel, collectionView, returnButton, buttonPaymentView, firstLabel, termOfUseLabel, paymentButton].forEach(view.setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonPaymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonPaymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonPaymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonPaymentView.heightAnchor.constraint(equalToConstant: 186),
            firstLabel.topAnchor.constraint(equalTo: buttonPaymentView.topAnchor, constant: 16),
            firstLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            termOfUseLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 4),
            termOfUseLabel.leadingAnchor.constraint(equalTo: firstLabel.leadingAnchor),
            paymentButton.topAnchor.constraint(equalTo: buttonPaymentView.topAnchor, constant: 76),
            paymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            collectionView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 212)
        ])
    }
    
    private func updatePaymentButton() {
        paymentButton.isEnabled = selectedMethodPay != nil
        
        if paymentButton.isEnabled {
            paymentButton.backgroundColor = .ypBlack
        } else {
            paymentButton.backgroundColor = .gray
        }
    }
    
    private func bind() {
        viewModel.currenciesObservable.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func didTapReturnButton() {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let firstWindow = firstScene.windows.first else { return }
        let vc = firstWindow.rootViewController
        vc?.dismiss(animated: true)
    }
    
    @objc private func didTapPaymentButton() {
        var vc = PurchaseResultViewController(completePurchase: false)
        if selectedMethodPay != nil {
            vc = PurchaseResultViewController(completePurchase: true)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    @objc private func didTapTermOfUseLabel() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
        let vc = WebViewController(url: url)
        present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        addView()
        applyConstraints()
        bind()
        viewModel.didLoad()
    }
}

extension PaymentChoiceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentChoiceCell.identifier, for: indexPath) as? PaymentChoiceCell else {
            return UICollectionViewCell()
        }
        let model = viewModel.currencies[indexPath.row]
        cell.configureCell(model: model)
        return cell
    }
}

extension PaymentChoiceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Int(collectionView.bounds.width) - 10) / 2, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PaymentChoiceCell else { return }
        guard let id = cell.currencyModel?.id else { return }
        viewModel.selectCurrency(with: id)
        cell.selectedCell()
        selectedMethodPay = viewModel.currencies[indexPath.row]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PaymentChoiceCell else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        cell.deselectedCell()
        selectedMethodPay = nil
    }
}
