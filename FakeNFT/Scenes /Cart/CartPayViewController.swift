//
//  CartPayViewController.swift
//  FakeNFT
//
//  Created by Александр Акимов on 29.04.2024.
//

import UIKit
import ProgressHUD

protocol CartPayViewControllerProtocol: AnyObject {
    var presenter: CartPayPresenterProtocol? { get set }
    func updateTable()
}

final class CartPayViewController: UIViewController & CartPayViewControllerProtocol {
    var presenter: CartPayPresenterProtocol? = CartPayPresenter(networkClient: DefaultNetworkClient())
    var num = 1

    private var visibleCurrencies: [Currencies] = []
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCellCollectionViewCart.self, forCellWithReuseIdentifier: CustomCellCollectionViewCart.reuseIdentifier)
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

    private let payButton: UIButton = {
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

    private let linkButton: UIButton = {
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
        let webViewVC = WebViewViewController()
        webViewVC.loadURL(url)
        present(webViewVC, animated: true)
    }

    @objc private func cancelPay() {
        dismiss(animated: true)
    }

    @objc private func payBttnTapped() {
        dismiss(animated: true)
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

    private func fetchCurrency() {
        ProgressHUD.show()
        guard let currencies = presenter?.fetchCurrenciesAndUpdate() else { return }
        visibleCurrencies = currencies
        ProgressHUD.dismiss()
        print(visibleCurrencies)
        updateTable()
    }

    private func configureView() {

        view.backgroundColor = .backgroundColor
        navigationItem.titleView = navigationLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackBttnCart.png"), style: .plain, target: self, action: #selector(cancelPay))
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
}

extension CartPayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(visibleCurrencies.count)
        return visibleCurrencies.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCellCollectionViewCart.reuseIdentifier,
                                                            for: indexPath) as? CustomCellCollectionViewCart else { return UICollectionViewCell() }
        let data = visibleCurrencies[indexPath.row]
        cell.initCell(currencyLabel: data.name, titleLabel: data.title)
        return cell
    }

}

extension CartPayViewController: UICollectionViewDelegate {

}

extension CartPayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 7 - 16 - 16) / 2
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
