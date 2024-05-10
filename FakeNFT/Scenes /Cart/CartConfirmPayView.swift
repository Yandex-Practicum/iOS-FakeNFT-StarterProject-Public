//
//  CartConfirmPayView.swift
//  FakeNFT
//
//  Created by Александр Акимов on 10.05.2024.
//

import UIKit

final class CartConfirmPayView: UIViewController {

    private let imageViews: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 12
        image.image = UIImage(named: "CartConfirm")
        return image
    }()

    private let payConfirmLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Cart.confirmPage.confirmLabel", comment: "")
        label.textColor = .blackDayText
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let returnButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Cart.confirmPage.continue", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: "blackDayNight")
        button.layer.cornerRadius = 16
        button.setTitleColor(.backgroundColor, for: .normal)
        button.addTarget(self, action: #selector(continueBttnTapped), for: .touchUpInside)
        return button
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()

    @objc
    private func continueBttnTapped() {
        let irer = Int.random(in: 0...1)
        switch irer {
        case 0:
            dismiss(animated: true)
        case 1:
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    print(viewController)
                }
            }
            navigationController.
        default:
            dismiss(animated: true)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraits()
    }

    private func configureView() {
        view.backgroundColor = .backgroundColor
        [stackView,
         returnButton].forEach {
            view.addSubview($0)
        }
        [imageViews,
         payConfirmLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func configureConstraits() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
