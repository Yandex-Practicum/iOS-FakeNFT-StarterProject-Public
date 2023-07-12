//
//  CartDeleteItemViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.06.2023.
//

import UIKit
import Combine

protocol CartDeleteCoordinatableProtocol {
    var idToDelete: String? { get set }
    var onCancel: (() -> Void)? { get set }
    var onDelete: (() -> Void)? { get set }
    func deleteItem(with id: String?)
}

final class CartDeleteItemViewController: UIViewController, CartDeleteCoordinatableProtocol {
    // CartDeleteCoordinatableProtocol
    var idToDelete: String?
    var onCancel: (() -> Void)?
    var onDelete: (() -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: CartDeleteViewModel
    
    private lazy var itemImageView: NftIMageView = {
        let imageView = NftIMageView(frame: .zero)
        return imageView
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textView.textColor = .ypBlack
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        textView.text = NSLocalizedString("Вы уверены, что хотите удалить объект из корзины?", comment: "")
        return textView
    }()
    
    private lazy var deleteButton: CustomActionButton = {
        let button = CustomActionButton(
            title: NSLocalizedString("Удалить", comment: ""),
            appearance: .cancel,
            cornerRadius: 12,
            fontWeight: .regular
        )
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: CustomActionButton = {
        let button = CustomActionButton(
            title: NSLocalizedString("Вернуться", comment: ""),
            appearance: .confirm,
            cornerRadius: 12,
            fontWeight: .regular
        )
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 41, bottom: 0, right: 41)
        stackView.spacing = 12
        stackView.addArrangedSubview(itemImageView)
        stackView.addArrangedSubview(messageTextView)
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(backButton)
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(itemImageView)
        stackView.addArrangedSubview(messageTextView)
        stackView.addArrangedSubview(buttonStackView)
        
        return stackView
    }()
    
    // MARK: Init
    init(viewModel: CartDeleteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlur()
        setupConstraints()
        updateItemToDelete(with: idToDelete)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
    
    private func bind() {
        viewModel.$itemToDelete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cartRow in
                self?.loadCover(for: cartRow?.images.first)
            }
            .store(in: &cancellables)
    }
    
    func updateItemToDelete(with id: String?) {
        viewModel.updateItemToDelete(with: id)
    }
    
    func deleteItem(with id: String?) {
        viewModel.deleteItem(with: id)
    }
    
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        
        view.addSubview(visualEffectView)
        
    }
    
    private func loadCover(for stringUrl: String?) {
        guard let url = viewModel.createUrl(from: stringUrl) else { return }
        itemImageView.setImage(from: url)
    }
}

// MARK: - Ext @objc
@objc private extension CartDeleteItemViewController {
    func deleteTapped() {
        onDelete?()
    }
    
    func cancelTapped() {
        onCancel?()
    }
}

// MARK: - Ext Constraints
extension CartDeleteItemViewController {
    func setupConstraints() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: (view.bounds.height * 0.3)),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.bounds.height * 0.35)),
            
            messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
}
