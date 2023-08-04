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
}

final class CartPaymentResultViewController: UIViewController, PaymentResultCoordinatable {

    var onMain: (() -> Void)?
    
    let viewModel: CartPaymentResultViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var actionButton: CustomActionButton = {
        let button = CustomActionButton(title: "", appearance: .confirm)
        return button
    }()
    
    private lazy var resultTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textView.textColor = .ypBlack
        textView.textAlignment = .center
        textView.textContainerInset.top = 0
        textView.backgroundColor = .clear
        return textView
    }()
    
    private lazy var resultView: CustomAnimatedView = {
        let view = CustomAnimatedView(frame: .zero)
        return view
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
        pay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        bind()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
    
    private func bind() {
        viewModel.$requestResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.updateUI(result)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Ext @objc
@objc private extension CartPaymentResultViewController {
    func returnToMainScreen() {
        onMain?()
    }
    
    func pay() {
        viewModel.pay()
    }
}

// MARK: - Ext private methods
private extension CartPaymentResultViewController {
    func updateUI(_ result: RequestResult?) {
        guard let result else { return }
        stopAnimation()
        updateTextView(by: result)
        updateResult(by: result)
        updateActionButton(result)
        startAnimation()
    }
    
    func stopAnimation() {
        resultView.stopAnimation()
    }
    
    func updateTextView(by result: RequestResult) {
        resultTextView.text = result.description
    }
    
    func updateResult(by result: RequestResult) {
        resultView.result = result
    }
    
    func updateActionButton(_ result: RequestResult) {
        actionButton.setTitle(result.buttonTitle, for: .normal)
        addButtonTarget(from: result)
        hideOrShowActionButton(by: result)
    }
    
    func addButtonTarget(from result: RequestResult) {
        switch result {
        case .success:
            actionButton.addTarget(self, action: #selector(returnToMainScreen), for: .touchUpInside)
        case .failure:
            actionButton.addTarget(self, action: #selector(pay), for: .touchUpInside)
        case .loading:
            break
        }
    }
    
    func hideOrShowActionButton(by result: RequestResult) {
        actionButton.isHidden = result == .loading
    }
    
    func startAnimation() {
        resultView.startAnimation()
    }
}

// MARK: - Ext Constraints
private extension CartPaymentResultViewController {
    func setupConstraints() {
        setupActionButton()
        setupAnimatedView()
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
    
    func setupAnimatedView() {
        view.addSubview(resultView)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultView.heightAnchor.constraint(equalToConstant: 75),
            resultView.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func setupResultStackView() {
        view.addSubview(resultTextView)
        resultTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            resultTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            resultTextView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: 0),
            resultTextView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 5)
            
        ])
    }
}
