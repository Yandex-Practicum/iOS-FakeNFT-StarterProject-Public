//
//  DeleteCardViewController.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 09.05.2024.
//

import Foundation
import UIKit

protocol CartDeleteControllerProtocol: AnyObject {
    func showNetworkError(message: String)
    func startLoadIndicator()
    func stopLoadIndicator()
}

final class DeleteCardViewController: UIViewController, CartDeleteControllerProtocol {
    
    private var presenter: DeleteCardPresenterProtocol?
    private (set) var nftImage: UIImage
    private var idForDelete: String
    
    init(nftImage: UIImage, idForDelete: String) {
        self.nftImage = nftImage
        self.idForDelete = idForDelete
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    
    private lazy var deleteCardView: UIView = {
        let deleteCardView = UIView()
        deleteCardView.translatesAutoresizingMaskIntoConstraints = false
        deleteCardView.layer.masksToBounds = true
        return deleteCardView
    }()
    
    private lazy var deleteCardImageView: UIImageView = {
        let  cardImageView = UIImageView()
        cardImageView.layer.masksToBounds = true
        cardImageView.layer.cornerRadius = 12
        cardImageView.image = self.nftImage
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        return  cardImageView
    }()
    
    private lazy var confirmationLabel: UILabel = {
        let confirmationLabel = UILabel()
        confirmationLabel.text = "Вы уверены, что хотите удалить объект из корзины?"
        confirmationLabel.numberOfLines = 2
        confirmationLabel.font = .caption2
        confirmationLabel.textAlignment = .center
        confirmationLabel.textColor = UIColor(named: "Black")
        confirmationLabel.translatesAutoresizingMaskIntoConstraints = false
        return confirmationLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Black")
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
        button.backgroundColor = UIColor(named: "Black")
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(UIColor(named: "White"), for: .normal)
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loaderView = LoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupLayoutDeleteCardView()
        setupLayout()
        
        presenter = DeleteCardPresenter(viewController: self, nftIdForDelete: idForDelete, nftImage: nftImage)
    }
    
    private func addSubviews() {
        let blur = UIBlurEffect(style: .light)
        blurView.effect = blur
        
        view.addSubview(blurView)
        view.addSubview(deleteCardView)
        view.addSubview(loaderView)
       
        deleteCardView.addSubview(deleteCardImageView)
        deleteCardView.addSubview(confirmationLabel)
        deleteCardView.addSubview(deleteButton)
        deleteCardView.addSubview(backButton)
        
        loaderView.constraintCenters(to: view)
    }
     
    private func setupLayoutDeleteCardView() {
        NSLayoutConstraint.activate([
            
            deleteCardImageView.heightAnchor.constraint(equalToConstant: 108),
            deleteCardImageView.widthAnchor.constraint(equalToConstant: 108),
            deleteCardImageView.centerXAnchor.constraint(equalTo: deleteCardView.centerXAnchor),
            deleteCardImageView.topAnchor.constraint(equalTo: deleteCardView.topAnchor),
            
            confirmationLabel.topAnchor.constraint(equalTo: deleteCardImageView.bottomAnchor, constant: 12),
            confirmationLabel.centerXAnchor.constraint(equalTo: deleteCardView.centerXAnchor),
            confirmationLabel.widthAnchor.constraint(equalToConstant: 260),

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
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            deleteCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            deleteCardView.widthAnchor.constraint(equalToConstant: 262),
            deleteCardView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    @objc func didTapDeleteButton() {
        presenter?.deleteNFTfromCart { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.dismiss(animated: true)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @objc private func didTapReturnButton() {
        self.dismiss(animated: true)
    }
    
    func startLoadIndicator() {
        loaderView.showLoading()
    }
    
    func stopLoadIndicator() {
        loaderView.hideLoading()
    }
    
    func showNetworkError(message: String) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Еще раз", style: .default) { _ in
            self.presenter?.deleteNFTfromCart { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.dismiss(animated: true)
                case let .failure(error):
                    print (error)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
   
}
