//
//  DeleteFromCartViewController.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//


import Combine
import UIKit

final class DeleteFromCartViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DeleteFromCartViewModel
    var confirmDeletion = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "card_luna")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let cuncelButton = ActionButton(
        size: .small,
        type: .primary,
        title: "Вернуться"
    )
    
    private let cofirmButton = ActionButton(
        size: .small,
        type:  .destructive,
        title: "Удалить"
    )
    
    private let confirmLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы уверены, что хотите\nудалить объект из корзины?"
        label.font = .caption2
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        view.frame = self.view.bounds
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ cofirmButton, cuncelButton ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ nftImageView, confirmLabel, horizontalStackView ])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: DeleteFromCartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        viewModel.confirmDeletion
            .sink { [weak self] in
                guard let self = self else { return }
                self.confirmDeletion.send()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(blurView)
        view.addSubview(mainStackView)
        
        [blurView, horizontalStackView, mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 220),
            
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            confirmLabel.heightAnchor.constraint(equalToConstant: 36),
            cofirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        setCustomSpacing()
        
        cuncelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        cofirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
    }
    
    private func setCustomSpacing() {
        mainStackView.setCustomSpacing(12, after: nftImageView)
        mainStackView.setCustomSpacing(20, after: confirmLabel)
    }
    
    // MARK: - Actions
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapConfirm() {
        viewModel.confirmDelete()
        dismiss(animated: true, completion: nil)
    }
}

