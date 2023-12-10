//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 10.12.2023.
//

import UIKit

final class CartViewController: UIViewController {
    private var viewModel: CartViewModel?

    // MARK: - UiElements
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Сart is empty", comment: "")
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "YPSort"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(CartViewController.self, action: #selector(sortButtonActions), for: .valueChanged)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("To pay", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "YPBlack")
        button.addTarget(CartViewController.self, action: #selector(paymentButtonActions), for: .valueChanged)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var quantityNFTLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor(named: "YPBlack")
        label.text = "0 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = "0 ETH"
        label.textColor = UIColor(named: "YPGreen")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var placeholderView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(named: "YPLightGrey")
        view.addSubview(totalAmountLabel)
        view.addSubview(quantityNFTLabel)
        view.addSubview(paymentButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityNFTLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quantityNFTLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            totalAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalAmountLabel.topAnchor.constraint(equalTo: quantityNFTLabel.bottomAnchor),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            paymentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            paymentButton.widthAnchor.constraint(equalToConstant: 240)
        ])
        return view
    }()

    // MARK: Initialisation
    init(viewModel: CartViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
        bind()
    }

    // MARK: Binding
    private func bind() {
        viewModel?.$nfts.bind(observer: { [weak self] _ in
            guard let self else { return }
            self.screenRenderingLogic()
        })
    }

    // MARK: - Actions
    @objc private func paymentButtonActions() {
    }

    @objc private func sortButtonActions() {
    }

    // MARK: - Private methods
    private func screenRenderingLogic() {
        guard let nfts = viewModel?.nfts else { return }
        if nfts.isEmpty {
            cartIsEmpty(empty: true)
        } else {
            cartIsEmpty(empty: false)
        }
    }

    private func configViews() {
        placeholderView.backgroundColor = UIColor(named: "YPLightGrey")
        view.backgroundColor = UIColor(named: "YPWhite")
        view.addSubview(placeholderLabel)
        view.addSubview(sortButton)
        view.addSubview(placeholderView)
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.heightAnchor.constraint(equalToConstant: 76)
        ])
    }

    private func cartIsEmpty(empty: Bool) {
        placeholderLabel.isHidden = !empty
        placeholderView.isHidden = empty
        sortButton.isHidden = empty
    }
}
