import UIKit
protocol CartPurchaseDelegate: AnyObject {
    func didTappedAgreementLink()
}

final class CartPurchaseViewController: UIViewController {
    private let numbersOfCurrencies = 8
    private let purchaseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold.size17
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.textAlignment = .center
        label.text = "Выберите способ оплаты"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let confirmView: ConfirmView = {
        let view = ConfirmView()
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let currencyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(CartPurchaseCell.self, forCellWithReuseIdentifier: CartPurchaseCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Backward"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self,
                         action: #selector(backButtonDidTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc func backButtonDidTapped() {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        setupView()
        confirmView.delegate = self
    }

    private func configureCollection() {
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
    }

    func setupView() {
        let backButtonItem = UIBarButtonItem(customView: backButton)
        let emptySpaceView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 1))
        let flexibleSpaceItem = UIBarButtonItem(customView: emptySpaceView)
        let titleLabelItem = UIBarButtonItem(customView: purchaseTitleLabel)
        navigationItem.leftBarButtonItems = [
            backButtonItem, flexibleSpaceItem, titleLabelItem
        ]
        view.backgroundColor = .white
        view.addSubview(currencyCollectionView)
        view.addSubview(confirmView)
        NSLayoutConstraint.activate([
            currencyCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currencyCollectionView.heightAnchor.constraint(equalToConstant: 205),

            confirmView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            confirmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmView.heightAnchor.constraint(equalToConstant: 186)
        ])
    }
    func presentNavigationController() {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
extension CartPurchaseViewController: UICollectionViewDelegate { }

extension CartPurchaseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbersOfCurrencies
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CartPurchaseCell.identifier,
            for: indexPath) as? CartPurchaseCell else {
            assertionFailure("Unable to dequeue CartPurchaseCell")
            return UICollectionViewCell()
    }
        cell.configureCell()
        return cell
    }
}

extension CartPurchaseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        let horizontalSpacing: CGFloat = 7
        let cellsPerRow: CGFloat = 2
        
        let width = (collectionView.bounds.width - horizontalSpacing) / cellsPerRow
        return CGSize(width: width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let minimumLineSpacing: CGFloat = 7
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let minimumInterSpacing: CGFloat = 7
        return minimumInterSpacing
    }
}

extension CartPurchaseViewController: CartPurchaseDelegate {
    func didTappedAgreementLink() {
        guard let url = URL(string: Constants.linkAgreement.rawValue)
        else { return }
        let request = URLRequest(url: url)
        let agreementVC = AgreementWebViewController(request: request)
        let navigationController = UINavigationController(rootViewController: agreementVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
