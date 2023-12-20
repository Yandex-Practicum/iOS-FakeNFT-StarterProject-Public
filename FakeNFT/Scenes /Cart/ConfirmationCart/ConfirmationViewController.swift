//
//  ConfirmationView.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 15.12.2023.
//

import UIKit

final class ConfirmationViewController: UIViewController {
    // MARK: - UiElements
    private lazy var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "YPPaymentSuccess")
        return imageView
    }()

    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.headline4
        label.textColor = UIColor(named: "YPBlack")
        label.text = NSLocalizedString("Success.payment", comment: "")
        return label
    }()

    private lazy var completedButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.bodyBold
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "YPBlack")
        button.setTitle(NSLocalizedString("Return.toCatalog", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(completedAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
    }

    // MARK: - Actions
    @objc private func completedAction() {
        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )
        let tabBarContoller = TabBarController(servicesAssembly: servicesAssembly)
        tabBarContoller.modalPresentationStyle = .fullScreen
        present(tabBarContoller, animated: true)
    }

    // MARK: - Private methods
    private func configViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        [successImageView, successLabel, completedButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 196),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            completedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completedButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
