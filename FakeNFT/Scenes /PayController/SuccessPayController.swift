//
//  SuccessPayController.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 08.05.2024.
//

import Foundation
import UIKit

final class SuccessPayController: UIViewController {
    
    private lazy var successImage: UIImageView = {
        let  successImage = UIImageView()
        successImage.image = UIImage(named: "Success")
        successImage.translatesAutoresizingMaskIntoConstraints = false
        return successImage   
    }()
    
    private lazy var successLabel: UILabel = {
        let successLabel = UILabel()
        successLabel.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        successLabel.font = .headline3
        successLabel.textAlignment = .center
        successLabel.numberOfLines = 2
        successLabel.textColor = UIColor(named: "Black")
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        return successLabel
    }()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Вернуться в каталог", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCatalogButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White")
        addSubviews()
        setupLayout()
    }

    private  func addSubviews() {

        view.addSubview(successImage)
        view.addSubview(successLabel)
        view.addSubview(returnButton)

    }
        
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            successImage.heightAnchor.constraint(equalToConstant: 278),
            successImage.widthAnchor.constraint(equalToConstant: 278),
            successImage.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            successImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            successLabel.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 25),
            
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    @objc func didTapCatalogButton() {
        self.dismiss(animated: true)
    }
}
