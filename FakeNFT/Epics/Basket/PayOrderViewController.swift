//
//  PayOrderViewController.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 06/08/2023.
//

import UIKit

final class CheckoutViewController: UIViewController {

    private lazy var payView: PayView = {
        let view = PayView()
//        view.delegate = self
        return view
    }()
    
    private lazy var backButton = UIBarButtonItem(
        image: UIImage.init(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

private extension CheckoutViewController {

    func setupView() {
        view.backgroundColor = UIColor.ypWhiteUniversal

        [payView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        view.addSubview(payView)

        setupNavBar()
        setupConstraints()
    }

    func setupNavBar() {
        title = "Выберите способ оплаты"

        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // payView
            payView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            payView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            payView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CheckoutViewController: UIGestureRecognizerDelegate {}

// MARK: - PayViewDelegate
extension CheckoutViewController: PayViewDelegate {

    func didTapPayButton() {
        // TODO: pay
    }

    func didTapUserAgreementLink() {
        let userAgreementViewController = UserAgreementViewController()
        navigationController?.pushViewController(userAgreementViewController, animated: true)
    }
}
