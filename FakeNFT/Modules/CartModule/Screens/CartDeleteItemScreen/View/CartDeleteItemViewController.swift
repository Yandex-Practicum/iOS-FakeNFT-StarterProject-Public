//
//  CartDeleteItemViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.06.2023.
//

import UIKit
import Combine
import Kingfisher

protocol CartDeleteCoordinatableProtocol {
    var idToDelete: UUID? { get set }
    var onCancel: (() -> Void)? { get set }
    var onDelete: (() -> Void)? { get set }
    func deleteItem(with id: UUID?)
}

final class CartDeleteItemViewController: UIViewController, CartDeleteCoordinatableProtocol {
    // CartDeleteCoordinatableProtocol
    var idToDelete: UUID?
    var onCancel: (() -> Void)?
    var onDelete: (() -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: CartDeleteViewModel
    
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var messageLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .ypBlack)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = NSLocalizedString("Вы уверены, что хотите удалить объект из корзины?", comment: "")
        return label
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
        stackView.addArrangedSubview(messageLabel)
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
        stackView.spacing = 20
        stackView.addArrangedSubview(upperStackView)
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
        bind()
        setupBlur()
        setupConstraints()
        updateItemToDelete(with: idToDelete)
        
    }
    
    private func bind() {
        viewModel.$itemToDelete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cartRow in
                self?.setupImageView(for: cartRow)
            }
            .store(in: &cancellables)
    }
    
    func updateItemToDelete(with id: UUID?) {
        viewModel.updateItemToDelete(with: id)
    }
    
    func deleteItem(with id: UUID?) {
        viewModel.deleteItem(with: id)
    }
    
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        
        view.addSubview(visualEffectView)
        
    }
    
    private func setupImageView(for cartRow: CartRow?) {
        guard let imageName = cartRow?.imageName else { return }
//        let processor = RoundCornerImageProcessor(cornerRadius: 12)
        itemImageView.kf.setImage(with: URL(string: imageName))
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
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -348)
        ])
    }
}
