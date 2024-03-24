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
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func cartIsEmpty(empty: Bool) {
        placeholderLabel.isHidden = !empty
    }
}
