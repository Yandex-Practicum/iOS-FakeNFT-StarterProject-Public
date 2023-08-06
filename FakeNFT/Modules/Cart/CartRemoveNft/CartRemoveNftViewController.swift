//
//  CartRemoveNftViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 06.08.2023.
//

import UIKit

final class CartRemoveNftViewController: UIViewController {
    enum RemoveNftFlow {
        case remove
        case cancel
    }

    var onChoosingRemoveNft: ((RemoveNftFlow) -> Void)?

    private let blurredEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let removeNftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CART_REMOVE_NFT_REMOVE_LABEL_TEXT".localized
        label.textAlignment = .center
        label.font = .getFont(style: .regular, size: 13)
        label.textColor = .appBlack
        label.numberOfLines = 0
        return label
    }()

    private lazy var removeNftButton: AppButton = {
        let button = AppButton(type: .nftCartRemove, title: "CART_REMOVE_NFT_REMOVE_BUTTON_TITLE".localized)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didTapRemoveNftButton), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: AppButton = {
        let button = AppButton(type: .nftCartCancel, title: "CART_REMOVE_NFT_CANCEL_BUTTON_TITLE".localized)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didTapCancelButton), for: .touchUpInside)
        return button
    }()

    init(nftImage: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.nftImageView.image = nftImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

private extension CartRemoveNftViewController {
    func configure() {
        self.view.backgroundColor = .clear
        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.blurredEffectView)
        self.view.addSubview(self.nftImageView)
        self.view.addSubview(self.removeNftLabel)
        self.view.addSubview(self.removeNftButton)
        self.view.addSubview(self.cancelButton)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.blurredEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.blurredEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.blurredEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.blurredEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            self.nftImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 244),
            self.nftImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 133),
            self.nftImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -134),
            self.nftImageView.heightAnchor.constraint(equalTo: self.nftImageView.widthAnchor),

            self.removeNftLabel.topAnchor.constraint(equalTo: self.nftImageView.bottomAnchor, constant: 12),
            self.removeNftLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 97),
            self.removeNftLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -98),

            self.removeNftButton.topAnchor.constraint(equalTo: self.removeNftLabel.bottomAnchor, constant: 20),
            self.removeNftButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 56),
            self.removeNftButton.trailingAnchor.constraint(equalTo: self.cancelButton.leadingAnchor, constant: -8),
            self.removeNftButton.widthAnchor.constraint(equalTo: self.cancelButton.widthAnchor),
            self.removeNftButton.heightAnchor.constraint(equalToConstant: 44),

            self.cancelButton.topAnchor.constraint(equalTo: self.removeNftLabel.bottomAnchor, constant: 20),
            self.cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -56),
            self.cancelButton.heightAnchor.constraint(equalTo: self.removeNftButton.heightAnchor)
        ])
    }
}

private extension CartRemoveNftViewController {
    @objc
    func didTapRemoveNftButton() {
        self.onChoosingRemoveNft?(.remove)
    }

    @objc
    func didTapCancelButton() {
        self.onChoosingRemoveNft?(.cancel)
    }
}
