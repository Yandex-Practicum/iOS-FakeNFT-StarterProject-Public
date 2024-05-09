//
//  PayViewController.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 07.05.2024.
//

import Foundation
import UIKit

protocol PayViewControllerProtocol: AnyObject {
    func updatePayCollection()
    func didSelectCurrency(isEnable: Bool)
    func didPay(payResult: Bool)
    func startLoadIndicator()
    func stopLoadIndicator()
}

final class PayViewController: UIViewController, PayViewControllerProtocol {
 
    private var presenter: PayPresenterProtocol?
    private let agreeUrl = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
    private var cartPresenter: CartPresenter?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var payCollectionView : UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: setupFlowLayout())
        collectionView.register(PayCell.self,
                                forCellWithReuseIdentifier: PayCell.identifier)
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
    private lazy var imagePay: UIView = {
        let imagePay = UIView()
        imagePay.backgroundColor = UIColor(named: "LightGray")
        imagePay.translatesAutoresizingMaskIntoConstraints = false
        imagePay.layer.masksToBounds = true
        imagePay.layer.cornerRadius = 12
        imagePay.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner ]
        return imagePay
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Совершая покупку, вы соглашаетесь с условиями"
        textLabel.font = .caption2
        textLabel.textColor = UIColor(named: "Black")
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var agreementLabel: UILabel = {
        let agreementLabel = UILabel()
        agreementLabel.font = .caption2
        agreementLabel.textColor = UIColor(named: "Blue")
        agreementLabel.attributedText = NSMutableAttributedString(string: "Пользовательского соглашения", attributes:[NSAttributedString.Key.link: agreeUrl!])
        
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        return agreementLabel
    }()
        
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loaderView = LoaderView()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White")
        
        presenter = PayPresenter(payController: self)
        
        makeNavBar()
        addSubviews()
        setupLayoutImagePay()
        setupLayout()
        payCollectionView.dataSource = self
        payCollectionView.delegate = self
        
        presenter?.getCurrencies()
    }
    
    
    private func makeNavBar()   {
        if let navBar = navigationController?.navigationBar {
            navigationItem.title = "Выберите способ оплаты"
            navBar.titleTextAttributes = [.font: UIFont.bodyBold]
            navBar.tintColor = UIColor(named: "Black")

            let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toCart))

            leftButton.image = UIImage(named: "Back")
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
        }
    }
    
    
    private func addSubviews() {
        view.addSubview(payCollectionView)
        view.addSubview(imagePay)
        imagePay.addSubview(textLabel)
        imagePay.addSubview(agreementLabel)
        imagePay.addSubview(payButton)
    }
        
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = .init(width: 168, height: 46)
        
        return layout
    }
    
    private func setupLayoutImagePay() {
        NSLayoutConstraint.activate([

            textLabel.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: imagePay.topAnchor, constant: 16),
            
            agreementLabel.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 16),
            agreementLabel.topAnchor.constraint(equalTo: imagePay.topAnchor, constant: 38),

            payButton.topAnchor.constraint(equalTo: imagePay.topAnchor, constant: 76),
            payButton.trailingAnchor.constraint(equalTo: imagePay.trailingAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            payCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            payCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            payCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            imagePay.topAnchor.constraint(equalTo:payCollectionView.bottomAnchor),
            imagePay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagePay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagePay.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
            imagePay.heightAnchor.constraint(equalToConstant: 154),
        ])
    }
    
    @objc func toCart() {
        let cartVC = CartViewController()
        present(cartVC, animated: true)
    }
    
    @objc private func didTapPayButton() {
        presenter?.payOrder()
    }
    
    func didSelectCurrency(isEnable: Bool) {
        payButton.isEnabled = isEnable
        payButton.backgroundColor = isEnable ? UIColor(named: "Black") : UIColor(named: "LightGray")
    }
    
    func updatePayCollection() {
        payCollectionView.reloadData()
    }
    
    func didPay(payResult: Bool) {
        didSelectCurrency(isEnable: true)
        if payResult {
            let successPayController = SuccessPayController()
            successPayController.modalPresentationStyle = .fullScreen
            present(successPayController, animated: true) {
                    self.navigationController?.popViewController(animated: true)
                    self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[0]
            }
        } else {
            showPayError()
        }
    }
    
    func startLoadIndicator() {
        loaderView.showLoading()
    }
    
    func stopLoadIndicator() {
        loaderView.hideLoading()
    }
    
    func showPayError() {
        let alert = UIAlertController(title: "", message: "Не удалось произвести оплату", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            self.dismiss(animated: true)
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { result in
            self.presenter?.payOrder()
        }
        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension  PayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = presenter?.count() else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PayCell.identifier, for: indexPath) as! PayCell
        guard let model = presenter?.getModel(indexPath: indexPath) else { return cell }
        cell.updateCell(currency: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PayCell
        cell?.selectCell(wasSelected: true)
        didSelectCurrency(isEnable: true)
        presenter?.selectedCurrency = cell?.currency
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PayCell
        cell?.selectCell(wasSelected: false)
    }
}

//extension PayViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 168, height: 46)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 7
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 7
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
//    }
//}




