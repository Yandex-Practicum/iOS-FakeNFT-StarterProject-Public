//
//  CheckoutViewController.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 06/08/2023.
//

import UIKit

final class CheckoutViewController: UIViewController, PayViewDelegate {
    private lazy var payView: PayView = {
        let view = PayView()
        view.delegate = self
        return view
    }()
    
    private lazy var backButton = UIBarButtonItem(
        image: UIImage.init(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )
    
    private lazy var currenciesCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.allowsMultipleSelection = false
        collection.register(CurrencyCell.self)
        return collection
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
    
    private var currencies: [CurrencyModel] = []
    private let currenciesService = CurrenciesService()
    private let orderService = OrderService()
    private var selectedCurrencyId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currenciesService.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencies):
                self.currencies = currencies
                DispatchQueue.main.async {
                    self.currenciesCollection.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        setupView()
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
//        navigationController?.popViewController(animated: true)
    }
    
    func didTapPayButton() {
        orderService.makePayment(currencyId: selectedCurrencyId ?? "") {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                var content: ResultsViewController.Content
                if response.success {
                    content = .init(
                        image: .paymentSuccess,
                        title: "Успех! Оплата прошла, поздравляем с покупкой!",
                        buttonTitle: "Вернуться в каталог",
                        buttonAction: {
                            self.tabBarController?.selectedIndex = 1
                            self.navigationController?.popToRootViewController(animated: false)
                        }
                    )
                } else {
                    content = .init(
                        image: .paymentError,
                        title: "Упс! Что-то пошло не так :(\n Попробуйте ещё раз!",
                        buttonTitle: "Попробовать еще раз",
                        buttonAction: { self.navigationController?.popViewController(animated: true) }
                    )
                }
                
                DispatchQueue.main.async {
                    let resultsViewController = ResultsViewController()
                    resultsViewController.configure(with: content)
                    self.navigationController?.pushViewController(resultsViewController, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didTapUserAgreementLink() {
        let userAgreementViewController = UserAgreementViewController()
        let navigationController = UINavigationController(rootViewController: userAgreementViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

private extension CheckoutViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteUniversal

        [
            payView,
            currenciesCollection
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        view.addSubview(payView)
        view.addSubview(currenciesCollection)

        setupNavBar()
        setupConstraints()
    }

    func setupNavBar() {
        title = "Выберите способ оплаты"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ypBlackUniversal]
        backButton.tintColor = .ypBlackUniversal
        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            payView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            payView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            payView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            currenciesCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currenciesCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currenciesCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currenciesCollection.bottomAnchor.constraint(equalTo: payView.topAnchor)
        ])
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
        let cell: CurrencyCell = collectionView.cellForItem(at: indexPath)
        selectedCurrencyId = currencies[indexPath.row].id
        cell.select()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell: CurrencyCell = collectionView.cellForItem(at: indexPath)
        cell.deselect()
    }
}

extension CheckoutViewController: UIGestureRecognizerDelegate {}
