//
//  ResultsViewController.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 16/08/2023.
//

import UIKit

protocol ResultsView: AnyObject {}

final class ResultsViewController: UIViewController, ResultsView {
    private let imageView = UIImageView()
    private let label: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private lazy var button: Button = {
        let button = Button(title: "")
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    private var buttonAction: (() -> Void)?
    
    private var presenter: ResultsPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ResultsPresenter(view: self)
        setupView()
    }

    @objc private func didTapButton() {
        buttonAction?()
    }

    func configure(with content: Content) {
        imageView.image = content.image
        label.text = content.title
        button.setTitle(content.buttonTitle, for: .normal)
        buttonAction = content.buttonAction
    }
}

private extension ResultsViewController {
    func setupView() {
        view.backgroundColor = .white

        [stackView, imageView, button]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        view.addSubview(stackView)
        view.addSubview(button)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        setupNavBar()
        setupConstraints()
    }

    func setupNavBar() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension ResultsViewController {
    struct Content {
        let image: UIImage?
        let title: String
        let buttonTitle: String
        let buttonAction: () -> Void
    }

    enum Constants {
        static let imageSize: CGFloat = 278
    }
}
