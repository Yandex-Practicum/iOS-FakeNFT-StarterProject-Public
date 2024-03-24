//
//  CartViewController.swift
//  FakeNFT
//
//  Created by admin on 25.03.2024.
//

import UIKit

final class CartViewController: UIViewController {
    private var viewModel: CartViewModel?
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Сart is empty", comment: "")
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(CartViewController.self, action: #selector(sortButtonActions), for: .valueChanged)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialisation
    
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
    
    // MARK: - Binding
    
    private func bind() {
        viewModel?.$nfts.bind(observer: { [weak self] _ in
            guard let self else { return }
            self.screenRenderingLogic()
        })
    }
    
    // MARK: - Actions
    
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
        view.backgroundColor = UIColor(named: "YPWhite")
        view.addSubview(placeholderLabel)
        view.addSubview(sortButton)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func cartIsEmpty(empty: Bool) {
        placeholderLabel.isHidden = !empty
    }
}
