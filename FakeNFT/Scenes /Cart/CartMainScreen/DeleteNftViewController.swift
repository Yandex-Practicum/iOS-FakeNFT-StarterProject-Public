//
//  DeleteNftViewController.swift
//  FakeNFT
//
//  Created by Кирилл Дробин on 02.04.2025.
//

import UIKit
import Kingfisher

final class DeleteNftViewController: UIViewController {
    // MARK: - Singletone
    private let storage = Storage.shared
    
    // MARK: - UI Elements
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.frame = view.bounds
        mainView.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var blur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = mainView.bounds
        return blurredEffectView
    }()
    
    private lazy var imageNft: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.backgroundColor = .red
        return image
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = NSLocalizedString("Вы уверены, что хотите\n удалить объект из корзины?", comment: "")
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "blackForDarkMode")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle(NSLocalizedString("Удалить", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didTapToDelete), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "blackForDarkMode")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(UIColor(named: "whiteForDarkMode"), for: .normal)
        button.setTitle(NSLocalizedString("Вернуться", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func addSubviews() {
        [
            mainView,
            blur,
            imageNft,
            label,
            deleteButton,
            backButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            imageNft.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 244),
            imageNft.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageNft.heightAnchor.constraint(equalToConstant: 108),
            imageNft.widthAnchor.constraint(equalToConstant: 108),
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 364),
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 36),
            label.widthAnchor.constraint(equalToConstant: 230),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 72),
            deleteButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 127),
            backButton.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 8)
        ])
    }
    
    @objc func didTapToDelete() {
        storage.mockCartNfts.remove(at: storage.cellIndexToDelete)
        NotificationCenter.default.post(name: Notification.Name("tabBar"), object: nil)
        dismissVC()
    }

    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
    
    func configureView(mainView: UIView) {
        imageNft.kf.setImage(with: URL(string: storage.mockCartNfts[storage.cellIndexToDelete].images.first ?? ""))
        self.mainView = mainView
    }
}

