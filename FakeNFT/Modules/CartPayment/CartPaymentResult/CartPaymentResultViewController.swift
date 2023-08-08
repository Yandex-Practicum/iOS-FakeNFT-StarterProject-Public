//
//  CartPaymentResultViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import UIKit

final class CartPaymentResultViewController: UIViewController {
    enum ResultType {
        case success
        case failure
    }

    var onResultButtonAction: (() -> Void)?

    private lazy var resultImageView: UIImageView = {
        let image: UIImage = self.resultType == .success ? .Cart.PaymentResult.success : .Cart.PaymentResult.failure
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let text = self.resultType == .success
            ? "CART_PAYMENT_RESULT_SUCCESS_LABEL_TEXT".localized
            : "CART_PAYMENT_RESULT_FAILURE_LABEL_TEXT".localized
        label.text = text
        label.font = .getFont(style: .bold, size: 22)
        label.textColor = .appBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var resultButton: AppButton = {
        let title = self.resultType == .success
            ? "CART_PAYMENT_RESULT_SUCCESS_BUTTON_TITLE".localized
            : "CART_PAYMENT_RESULT_FAILURE_BUTTON_TITLE".localized

        let button = AppButton(type: .filled, title: title)
        button.addTarget(self, action: #selector(self.didTapResultButton), for: .touchUpInside)
        return button
    }()

    private let resultType: ResultType

    init(resultType: ResultType) {
        self.resultType = resultType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

private extension CartPaymentResultViewController {
    func configure() {
        self.view.backgroundColor = .appWhite
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.resultImageView)
        self.view.addSubview(self.resultLabel)
        self.view.addSubview(self.resultButton)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.resultImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 152),
            self.resultImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            self.resultImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            self.resultImageView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -304
            ),

            self.resultLabel.topAnchor.constraint(equalTo: self.resultImageView.bottomAnchor, constant: 20),
            self.resultLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 36),
            self.resultLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -36),

            self.resultButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.resultButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.resultButton.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            self.resultButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - Actions
private extension CartPaymentResultViewController {
    @objc
    func didTapResultButton() {
        self.onResultButtonAction?()
    }
}
