//
//  DeleteCardViewController.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 09.05.2024.
//

import Foundation
import UIKit

final class DeleteCardViewController: UIViewController {
    
    private lazy var deleteCardView: UIView = {
        let deleteCardView = UIView()
        deleteCardView.backgroundColor = .none
        deleteCardView.translatesAutoresizingMaskIntoConstraints = false
        deleteCardView.layer.masksToBounds = true
        return deleteCardView
    }()
    
    private lazy var deleteCardImageView: UIImageView = {
        let  cardImageView = UIImageView()
        cardImageView.layer.cornerRadius = 12
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        return  cardImageView
    }()
    
    private lazy var confirmationLabel: UILabel = {
        let confirmationLabel = UILabel()
        confirmationLabel.text = "Вы уверены, что хотите удалить объект из корзины?"
        confirmationLabel.numberOfLines = 2
        confirmationLabel.font = .caption2
        confirmationLabel.textColor = UIColor(named: "Black")
        confirmationLabel.translatesAutoresizingMaskIntoConstraints = false
        return confirmationLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(UIColor(named: "Red"), for: .normal)
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(UIColor(named: "White"), for: .normal)
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .none
        
        addSubviews()
        setupLayoutDeleteCardView()
        setupLayout()

    }
    
    private func addSubviews() {
        view.addSubview(deleteCardView)
        
        deleteCardView.addSubview(deleteCardImageView)
        deleteCardView.addSubview(confirmationLabel)
        deleteCardView.addSubview(deleteButton)
        deleteCardView.addSubview(backButton)
    }
    

        
    private func setupLayoutDeleteCardView() {
        NSLayoutConstraint.activate([
            
            deleteCardImageView.heightAnchor.constraint(equalToConstant: 108),
            deleteCardImageView.widthAnchor.constraint(equalToConstant: 108),
            deleteCardImageView.centerXAnchor.constraint(equalTo: deleteCardView.centerXAnchor),
            deleteCardImageView.topAnchor.constraint(equalTo: deleteCardView.topAnchor),
            
            confirmationLabel.topAnchor.constraint(equalTo: deleteCardImageView.bottomAnchor, constant: 16),
            confirmationLabel.centerXAnchor.constraint(equalTo: deleteCardView.centerXAnchor),

            deleteButton.bottomAnchor.constraint(equalTo: deleteCardView.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: deleteCardView.leadingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.bottomAnchor.constraint(equalTo: deleteCardView.bottomAnchor),
            backButton.trailingAnchor.constraint(equalTo: deleteCardView.trailingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 127),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            deleteCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            deleteCardView.widthAnchor.constraint(equalToConstant: 262),
            deleteCardView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    @objc func didTapDeleteButton() {
        // TO DO: реализовать удаление карточки
    }
    
    @objc private func didTapReturnButton() {
        let payVC = PayViewController()
        present(payVC, animated: true)
    }
    
    
}
