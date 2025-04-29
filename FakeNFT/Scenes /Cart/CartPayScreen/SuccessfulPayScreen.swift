//
//  SuccessfulPayScreen.swift
//  FakeNFT
//
//  Created by Кирилл Дробин on 27.03.2025.
//

import UIKit

final class SuccessfulPayScreen: UIViewController {
    // MARK: - Singletone
    private let storage = Storage.shared
    
    // MARK: - Private Properties
    private lazy var successImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "successfulPayImage")
        return image
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var backToCatalogButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "blackForDarkMode")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(named: "whiteForDarkMode"), for: .normal)
        button.setTitle(NSLocalizedString("Вернуться в каталог", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(backToCatalogAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "whiteForDarkMode")
        addSubviews()
        makeConstraints()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [
            successImage,
            successLabel,
            backToCatalogButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            successImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 196),
            successImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 49),
            successImage.heightAnchor.constraint(equalToConstant: 278),
            successImage.widthAnchor.constraint(equalToConstant: 278),
            
            successLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36),
            successLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -262),
            successLabel.heightAnchor.constraint(equalToConstant: 56),
            
            backToCatalogButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backToCatalogButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            backToCatalogButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            backToCatalogButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    // MARK: - Objc Methods
    @objc func backToCatalogAction() {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 1
        storage.mockCartNfts.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
}
