//
//  PayViewController.swift
//  FakeNFT
//
//  Created by Кирилл Дробин on 23.03.2025.
//

import SafariServices
import UIKit

final class PayViewController: UIViewController {
    // MARK: - Singletone
    private let storage = Storage.shared
    private let paymentNetworkService = PaymentNetworkService.shared
    
    // MARK: - Private Properties
    private var currencyID = String()
    
    private lazy var cryptoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var payFieldView: UIView = {
        let payView = UIView()
        payView.backgroundColor = UIColor(named: "greyForDarkMode")
        payView.layer.cornerRadius = 12
        payView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return payView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var termsOfUseLink: UIButton = {
        let button = UIButton()
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.setTitleColor(UIColor(red: 10/255, green: 132/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.addTarget(self, action: #selector(showTermsOfUse), for: .touchUpInside)
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "blackForDarkMode")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(named: "whiteForDarkMode"), for: .normal)
        button.setTitle(NSLocalizedString("Оплатить", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didPayButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = UIColor(named: "whiteForDarkMode")
        navigationBarSetup()
        cryptoCollectionView.dataSource = self
        cryptoCollectionView.delegate = self
        cryptoCollectionView.register(CryptoCellView.self, forCellWithReuseIdentifier: "cell")
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Private Methods
    private func navigationBarSetup() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "blackForDarkMode")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(backButton))
        
        self.navigationItem.title = "Выберите способ оплаты"
    }
    
    private func collectionViewSetup() {
        DispatchQueue.main.async {
            self.paymentNetworkService.getCurrencies { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    self.updateCollectionViewAnimated(for: cryptoCollectionView)
                    self.paymentNetworkService.getOrder { [weak self] result in
                        guard self != nil else { return }
                        switch result {
                        case .success:
                            print("get order ok")
                        case .failure:
                            print("No get order")
                        }
                    }
                case .failure:
                    print("getCurrencies error")
                }
            }
        }
    }
    
    private func updateCollectionViewAnimated(for collectionView: UICollectionView) {
        DispatchQueue.main.async { 
            collectionView.reloadData()
        }
    }
    
    private func addSubviews() {
        [
            cryptoCollectionView,
            payFieldView,
            descriptionLabel,
            termsOfUseLink,
            payButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            cryptoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cryptoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            cryptoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            cryptoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 465),
            
            payFieldView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            payFieldView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            payFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            payFieldView.heightAnchor.constraint(equalToConstant: 186),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: payFieldView.bottomAnchor, constant: -152),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            
            termsOfUseLink.bottomAnchor.constraint(equalTo: payFieldView.bottomAnchor, constant: -130),
            termsOfUseLink.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            termsOfUseLink.widthAnchor.constraint(equalToConstant: 202),
            termsOfUseLink.heightAnchor.constraint(equalToConstant: 18),
            
            payButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    private func showAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Не удалось произвести оплату", message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { action in
            alert.dismiss(animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Повторить", style: .cancel, handler: { action in
            self.didPayButton()
            alert.dismiss(animated: false)
        }))
    }
    
    @objc private func backButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func showTermsOfUse() {
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @objc private func didPayButton() {
        let successfulPayScreen = SuccessfulPayScreen()
        
        paymentNetworkService.setCurrencyBeforePay(currencyID: currencyID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.paymentNetworkService.updateOrder { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success:
                        storage.forCurrenciesCollection.removeAll()
                        self.navigationController?.pushViewController(successfulPayScreen, animated: true)
                    case .failure:
                        self.showAlert(vc: successfulPayScreen)
                    }
                }
            case .failure:
                self.showAlert(vc: successfulPayScreen)
            }
        }
    }
}

// MARK: - UICollectionView Setup
extension PayViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        storage.forCurrenciesCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CryptoCellView else { return CryptoCellView()}
        
        cell.cellSetup(imageUrl: URL(string: storage.forCurrenciesCollection[indexPath.row].image) ?? URL(fileURLWithPath: "no url"),
                       name: storage.forCurrenciesCollection[indexPath.row].title,
                       shortName: storage.forCurrenciesCollection[indexPath.row].name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellHeight: CGFloat = 46.0
        let cellsPerRow: CGFloat = 2.0
        let cellSpacing: CGFloat = 7.0
        
        let paddingWidth: CGFloat = 16 + 16 + (cellsPerRow - 1) * cellSpacing
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth =  availableWidth / CGFloat(cellsPerRow)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { 7 }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CryptoCellView
        cell?.layer.cornerRadius = 12
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor(named: "blackForDarkMode")?.cgColor
        payButton.isEnabled = true
        currencyID = storage.forCurrenciesCollection[indexPath.row].id
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CryptoCellView
        cell?.layer.borderColor = UIColor.clear.cgColor
    }
}
