import UIKit
import ProgressHUD
import Kingfisher

protocol CartPayViewControllerProtocol: AnyObject {
    var presenter: CartPayPresenterProtocol? { get set }
    var visibleCurrencies: [Currencies] { get set }
    func updateTable()
}

protocol CartPayViewDelegate: AnyObject {
    func updateCart()
}

final class CartPayViewController: UIViewController & CartPayViewControllerProtocol {
    var presenter: CartPayPresenterProtocol? = CartPayPresenter(networkClient: DefaultNetworkClient())
    var num = 1

    var visibleCurrencies: [Currencies] = []
    weak var delegate: CartPayViewDelegate?

    private var selectedCurrency: String?

    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return nil
        }
        return window
    }

    private let navigationLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите способ оплаты"
        label.textColor = .blackDayText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private let currencysCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCellCollectionViewCart.self,
                                forCellWithReuseIdentifier: CustomCellCollectionViewCart.reuseIdentifier)
        return collectionView
    }()

    private let payView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .segmentInactive
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Cart.payPage.payBttn", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: "blackDayNight")
        button.layer.cornerRadius = 16
        button.setTitleColor(.backgroundColor, for: .normal)
        button.addTarget(self, action: #selector(payBttnTapped), for: .touchUpInside)
        return button
    }()

    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.textColor = .blackDayText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.blueUniversal, for: .normal)
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        return button
    }()

    @objc private func openWebView() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
        let webViewVC = CartWebViewController()
        webViewVC.loadURL(url)
        present(webViewVC, animated: true)
    }

    @objc private func cancelPay() {
        if ProgressHUD.areAnimationsEnabled {
            ProgressHUD.dismiss()
        }
        dismiss(animated: true)
    }

    @objc private func payBttnTapped() {
        tryToPay()
    }

    @objc func handleDataUpdate(_ notification: Notification) {
        if notification.userInfo != nil {
            dismiss(animated: true)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraits()
        presenter?.view = self
        fetchCurrency()
    }

    func updateTable() {
        currencysCollectionView.reloadData()
    }

    func makeAlert() {
        let alert = UIAlertController(title: "Не удалось произвести оплату", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in
            self.tryToPay()
            alert.dismiss(animated: true)
        }))

        present(alert, animated: true)
    }

    private func fetchCurrency() {
        DispatchQueue.main.async {
            ProgressHUD.show()
            CartPayViewController.window?.isUserInteractionEnabled = false
            self.presenter?.getCurrencies { [weak self] items in
                guard let self = self else { return }
                switch items {
                case .success(let currencies):
                    self.visibleCurrencies = currencies
                case .failure(let error):
                    print(error)
                }
                updateTable()
                CartPayViewController.window?.isUserInteractionEnabled = true
                ProgressHUD.dismiss()
            }
        }
    }

    private func tryToPay() {
        guard let selectedCurrency = selectedCurrency else { return }
        DispatchQueue.main.async {
            ProgressHUD.show()
            CartPayViewController.window?.isUserInteractionEnabled = false
            self.presenter?.getPayAnswer(currencyId: selectedCurrency) { [weak self] items in
                guard let self = self else { return }
                switch items {
                case .success(let answer):
                    if answer.success == true {
                        makeTransitionToConfirmPage()
                    } else {
                        makeAlert()
                    }
                case .failure(let error):
                    print(error)
                }
                CartPayViewController.window?.isUserInteractionEnabled = true
                ProgressHUD.dismiss()
            }
        }
    }

    private func makeTransitionToConfirmPage() {
        let confirmPage = CartConfirmPayView()
        let navigationController = UINavigationController(rootViewController: confirmPage)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true)
    }

    private func configureView() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdate(_:)), name: NSNotification.Name("CartClean"), object: nil)
        payButton.isEnabled = false
        view.backgroundColor = .backgroundColor
        navigationItem.titleView = navigationLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBttnCart.png"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelPay))
        navigationItem.leftBarButtonItem?.tintColor = .blackDayText
        [currencysCollectionView,
         payView].forEach {
            view.addSubview($0)
        }

        [agreementLabel,
         linkButton,
         payButton].forEach {
            payView.addSubview($0)
        }
        currencysCollectionView.delegate = self
        currencysCollectionView.dataSource = self
    }

    private func configureConstraits() {
        NSLayoutConstraint.activate([
            currencysCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencysCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencysCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencysCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            payView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            payView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            payView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            agreementLabel.leadingAnchor.constraint(equalTo: payView.leadingAnchor, constant: 16),
            agreementLabel.topAnchor.constraint(equalTo: payView.topAnchor, constant: 16),
            linkButton.leadingAnchor.constraint(equalTo: payView.leadingAnchor, constant: 16),
            linkButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor),

            payButton.leadingAnchor.constraint(equalTo: payView.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: payView.trailingAnchor, constant: -12),
            payButton.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: payView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func enableButton() {
        if selectedCurrency != nil {
            payButton.isEnabled = true
        }
    }
}

extension CartPayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCurrencies.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                CustomCellCollectionViewCart.reuseIdentifier,
                                                            for: indexPath) as? CustomCellCollectionViewCart else { return UICollectionViewCell() }
        let data = visibleCurrencies[indexPath.row]
        let url = URL(string: data.image)
        cell.imageViews.kf.setImage(with: url)
        cell.initCell(currencyLabel: data.name, titleLabel: data.title)
        return cell
    }

}

extension CartPayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCellCollectionViewCart {
            cell.layer.borderWidth = 1
            let color: UIColor = .blackDayText
            cell.layer.cornerRadius = 12
            cell.layer.borderColor = color.cgColor
        }
        selectedCurrency = visibleCurrencies[indexPath.row].id
        enableButton()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCellCollectionViewCart {
            cell.layer.borderWidth = 0
            let color: UIColor = .blackDayText
            cell.layer.cornerRadius = 12
            cell.layer.borderColor = color.cgColor
        }
    }
}

extension CartPayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let indentFromView: CGFloat = 16
        let indentBetweenCells: CGFloat = 7
        let width = (collectionView.bounds.width - indentBetweenCells - (indentFromView * 2)) / 2
        let height: CGFloat = 46
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7 // Отступ между рядами ячеек
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

}
