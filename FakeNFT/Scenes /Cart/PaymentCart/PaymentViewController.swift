//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 14.12.2023.
//

import UIKit

final class PaymentViewController: UIViewController {
    private var viewModel: PaymentViewModel?

    // MARK: - UiElements
    private let navigationBar = UINavigationBar()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Select a Payment Method", comment: "")
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "YPBackward"), for: .normal)
        button.addTarget(self, action: #selector(backButtonActions), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: Initialisation
    init(viewModel: PaymentViewModel) {
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
        configNavigationBar()
        bind()
    }

    // MARK: Binding
    private func bind() {
        viewModel?.$order.bind(observer: { [weak self] _ in
            guard let self else { return }
        })
    }

    // MARK: - Actions
    @objc private func backButtonActions() {
        dismiss(animated: true)
    }

    // MARK: - Private methods
    private func configNavigationBar() {
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.titleView = titleLabel
        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = UIColor(named: "YPWhite")
        navigationBar.shadowImage = UIImage()
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configViews() {
        view.backgroundColor = UIColor(named: "YPWhite")
        view.addSubview(navigationBar)
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
