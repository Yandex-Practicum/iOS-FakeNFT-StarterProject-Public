//
//  DeleteModalViewController.swift
//  FakeNFT
//
//  Created by Svetlana Varenova on 02.12.2025.
//

import UIKit

final class DeleteModalViewController: UIViewController {
    
    private let nftImage: UIImage?
    private let nftTitle: String
    private let onDelete: () -> Void
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    private let containerView = UIView()
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    init(image: UIImage?, title: String, onDelete: @escaping () -> Void) {
        self.nftImage = image
        self.nftTitle = title
        self.onDelete = onDelete
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlur()
        setupUI()
    }
    
    private func setupBlur() {

        view.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupUI() {
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        imageView.image = nftImage
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = NSLocalizedString("Are you sure you want to\n remove the item from the cart?", comment: "")
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.setTitle(NSLocalizedString("button.Delete", comment: ""), for: .normal)
        deleteButton.backgroundColor = UIColor.segmentButtonBackground
        deleteButton.layer.cornerRadius = 12
        deleteButton.setTitleColor(UIColor.redUniversal, for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        cancelButton.setTitle(NSLocalizedString("button.GoBack", comment: ""), for: .normal)
        cancelButton.backgroundColor = UIColor.segmentButtonBackground
        cancelButton.layer.cornerRadius = 12
        cancelButton.setTitleColor(UIColor.segmentButtonText, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -57),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 41),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -41),
            
            deleteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 12),
            cancelButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func deleteTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onDelete()
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
}


