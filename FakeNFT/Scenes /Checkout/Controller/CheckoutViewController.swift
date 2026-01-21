import UIKit

final class CheckoutViewController: UIViewController, CheckoutViewProtocol {
    private let checkoutView = CheckoutView()
    private var currencies: [CurrencyModel] = []
    private let currenciesService: CurrenciesService = .shared
    private let orderService = OrderService.shared
    private var selectedCurrencyId: String?
    
    private lazy var backButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
    }()
    
    private let collectionConfig = UICollectionView.Configure(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        topInset: 0,
        bottomInset: 0,
        height: 46,
        cellSpacing: 8
    )
    
    override func loadView() {
        view = checkoutView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        checkoutView.setDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkoutView.showHud()
        loadCurrencies()
    }
    
    private func loadCurrencies() {
        currenciesService.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencies):
                DispatchQueue.main.async {
                    self.updateCurrencies(currencies)
                    self.checkoutView.removeHud()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupNavBar() {
        title = "Выберите способ оплаты"
        navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .yaBlackLight
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yaBlackLight]
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    func showHud() {
        checkoutView.showHud()
    }
    
    func removeHud() {
        checkoutView.removeHud()
    }
    
    func updateCurrencies(_ currencies: [CurrencyModel]) {
        self.currencies = currencies
        checkoutView.updateCurrencies(currencies)
    }
    
    func didSelectCurrency(id: String?) {
        selectedCurrencyId = id
    }
}

extension CheckoutViewController: PayViewDelegate {
    func didTapPayButton() {
        guard let selectedCurrencyId else { return }
        orderService.makePayment(currencyId: selectedCurrencyId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.displayPaymentResult(success: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.displayPaymentResult(success: false)
                }
            }
        }
    }
    
    func displayPaymentResult(success: Bool) {
        if (selectedCurrencyId != nil) {
            if success {
                let content: ResultsViewController.Content =
                    .init(image: UIImage(named: "paymentSuccess"), title: "Успех! Оплата прошла, поздравляем с покупкой!", buttonTitle: "Вернуться в каталог") { [weak self] in
                        self?.tabBarController?.selectedIndex = 1
                        self?.dismiss(animated: true)
                    }
                
                let resultsViewController = ResultsViewController()
                resultsViewController.configure(with: content)
                navigationController?.pushViewController(resultsViewController, animated: true)
            } else {
                let alertController = UIAlertController(title: "Не удалось произвести оплату", message: "", preferredStyle: .alert)
                
                let firstAction = UIAlertAction(title: "Отменить", style: .default) { _ in
                    alertController.dismiss(animated: true)
                }
                
                let secondAction = UIAlertAction(title: "Повторить", style: .cancel) { _ in
                    self.didTapPayButton()
                }
                
                alertController.addAction(firstAction)
                alertController.addAction(secondAction)
                
                present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    func didTapUserAgreementLink() {
        let userAgreementViewController = UserAgreementViewController()
        let navigationController = UINavigationController(rootViewController: userAgreementViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true)
    }
}

extension CheckoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let model = currencies[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
}

extension CheckoutViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableSpace = collectionView.frame.width - collectionConfig.paddingWidth
        let cellWidth = availableSpace / collectionConfig.cellCount
        return CGSize(width: cellWidth, height: collectionConfig.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: collectionConfig.topInset,
            left: collectionConfig.leftInset,
            bottom: collectionConfig.bottomInset,
            right: collectionConfig.rightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        collectionConfig.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionConfig.cellSpacing
    }
}

extension CheckoutViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCurrency(id: currencies[indexPath.row].id)
        let cell = collectionView.cellForItem(at: indexPath) as? CurrencyCell
        
        cell?.select()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CurrencyCell
        cell?.deselect()
    }
}

extension CheckoutViewController: UIGestureRecognizerDelegate {}
