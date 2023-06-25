//
//  CartPaymentResultViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 24.06.2023.
//

import UIKit
import Combine

protocol PaymentResultCoordinatable {
    var onMain: (() -> Void)? { get set }
    var onRetry: (() -> Void)? { get set }
}

final class CartPaymentResultViewController: UIViewController, PaymentResultCoordinatable {

    var onMain: (() -> Void)?
    var onRetry: (() -> Void)?
    
    let viewModel: CartPaymentResultViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var actionButton: CustomActionButton = {
        let button = CustomActionButton(title: "", appearance: .confirm)
        return button
    }()
    
    private lazy var resultLabel: CustomLabel = {
        let label = CustomLabel(size: 22, weight: .bold, color: .ypBlack, alignment: .center)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var resultStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        stackView.addArrangedSubview(resultImageView)
        stackView.addArrangedSubview(resultLabel)
        
        return stackView
    }()
    
    // MARK: Init
    init(viewModel: CartPaymentResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
        bind()
        viewModel.updatePaymentResultView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    private func bind() {
        viewModel.$requestResult
            .sink { [weak self] result in
                DispatchQueue.main.async {
                    self?.updateUI(result)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(_ result: RequestResult?) {
        guard let result else { return }
        switch result {
        case .success, .failure:
            self.actionButton.setTitle(result.buttonTitle, for: .normal)
            self.resultLabel.text = result.description
            self.resultImageView.image = result.image
        case .loading:
            self.actionButton.setTitle("Loading...", for: .normal)
            self.resultLabel.text = "Loading in progress"
            self.resultImageView.image = UIImage(named: K.Icons.circleDotted)
        }
        self.actionButton.isHidden = result == .loading
    }  
}

// MARK: - Ext Constraints
private extension CartPaymentResultViewController {
    func setupConstraints() {
        setupActionButton()
        setupResultStackView()
    }
    
    func setupActionButton() {
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupResultStackView() {
        view.addSubview(resultStackView)
        resultStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            resultStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            resultStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 152)
        ])
    }
}
