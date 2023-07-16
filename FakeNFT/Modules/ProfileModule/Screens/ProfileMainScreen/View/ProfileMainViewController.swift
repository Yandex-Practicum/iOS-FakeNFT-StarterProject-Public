//
//  ProfileMainViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 15.07.2023.
//

import UIKit

protocol ProfileMainCoordinatableProtocol {
    var onEdit: (() -> Void)? { get set }
}

final class ProfileMainViewController: UIViewController, ProfileMainCoordinatableProtocol {

    var onEdit: (() -> Void)?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var authorNameLabel: CustomLabel = {
        let label = CustomLabel(size: 22, weight: .bold, color: .ypBlack)
        return label
    }()
    
    private lazy var authorImageAndNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(authorNameLabel)
        return stackView
    }()
    
    private lazy var descriptionTextView: DescriptionTextView = {
        let textView = DescriptionTextView(frame: .zero, textContainer: nil)
        return textView
    }()
    
    private lazy var authorWebsiteLabel: CustomLabel = {
        let label = CustomLabel(size: 15, weight: .regular, color: .universalBlue)
        return label
    }()
    
    private lazy var authorMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(authorImageAndNameStackView)
        stackView.addArrangedSubview(descriptionTextView)
        stackView.addArrangedSubview(authorWebsiteLabel)
        return stackView
    }()
    
    private let viewModel: ProfileMainViewModel
    
    // MARK: Init
    init(viewModel: ProfileMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
    }
    
    
    

}

// MARK: - Ext Constraints
private extension ProfileMainViewController {
    func setupConstraints() {
        setupMainStackView()
    }
    
    func setupMainStackView() {
        view.addSubview(authorMainStackView)
        authorMainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorMainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            authorMainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            authorMainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
