//
//  RemoveNFTViewController.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 03/08/2023.
//

import UIKit

protocol RemoveNFTView: AnyObject {
    func updateImage(with url: URL?)
}

protocol RemoveNFTViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didTapConfirmButton(_ model: NftModel)
}

final class RemoveNFTViewController: UIViewController, RemoveNFTView {
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .ypBlackUniversal
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        return label
    }()
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var cancelButton: Button = {
        let button = Button(title: "Вернуться")
            .font(.bodyRegular)
            .cornerRadius(12)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    private lazy var confirmButton: Button = {
        let button = Button(title: "Удалить")
            .titleColor(.red)
            .font(.bodyRegular)
            .cornerRadius(12)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: RemoveNFTViewControllerDelegate?
    private var model: NftModel?
    private var presenter: RemoveNFTPresenter?
    
    init(nftModel: NftModel, delegate: RemoveNFTViewControllerDelegate) {
        self.model = nftModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RemoveNFTPresenter(view: self, delegate: delegate)
        if let model = model {
            presenter?.configure(with: model)
        }
        
        setupView()
    }

    func updateImage(with url: URL?) {
        if let url = url {
            nftImageView.kf.setImage(with: url)
        }
    }
    
    @objc private func didTapCancelButton() {
        presenter?.didTapCancelButton()
    }
    
    @objc private func didTapConfirmButton() {
        presenter?.didTapConfirmButton()
    }
}

private extension RemoveNFTViewController {
    func setupView() {
        [nftImageView, alertLabel, buttonsStackView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(blurView)
        view.addSubview(nftImageView)
        view.addSubview(alertLabel)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(confirmButton)
        buttonsStackView.addArrangedSubview(cancelButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.centerXAnchor.constraint(equalTo: alertLabel.centerXAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: alertLabel.topAnchor, constant: -12),
            nftImageView.widthAnchor.constraint(equalToConstant: BasketNFTCell.Constants.imageSize),
            nftImageView.heightAnchor.constraint(equalToConstant: BasketNFTCell.Constants.imageSize),
            
            alertLabel.widthAnchor.constraint(equalToConstant: 180),
            alertLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: alertLabel.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: alertLabel.bottomAnchor, constant: 20),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 262),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
