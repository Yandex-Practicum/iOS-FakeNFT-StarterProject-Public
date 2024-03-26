//
//  CryptoWalletCell.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 25.03.2024.
//

import UIKit

class CryptoWalletCell: UICollectionViewCell {
    
    let cryptoBacground: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ypLightGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var cryptoImage: UIImageView = {
        // Загружаем изображение по имени
        let image = UIImage(named: "Bitcoin (BTC)")
        // Создаем UIImageView с этим изображением
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit // Настраиваем режим отображения
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var fullNameCrypto: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "Bitcoin"
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        label.widthAnchor.constraint(equalToConstant: 60).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shortNameCrypto: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "BTC"
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        label.widthAnchor.constraint(equalToConstant: 37).isActive = true
        label.textColor = UIColor(named: "ypUniGreen")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cryptoBacground)
        cryptoBacground.addSubview(cryptoImage)
        cryptoBacground.addSubview(fullNameCrypto)
        cryptoBacground.addSubview(shortNameCrypto)
        
        NSLayoutConstraint.activate([
            cryptoBacground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cryptoBacground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cryptoBacground.topAnchor.constraint(equalTo: contentView.topAnchor),
            cryptoBacground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
            cryptoImage.leadingAnchor.constraint(equalTo: cryptoBacground.leadingAnchor, constant: 12),
            cryptoImage.topAnchor.constraint(equalTo: cryptoBacground.topAnchor, constant: 5),
            cryptoImage.bottomAnchor.constraint(equalTo: cryptoBacground.bottomAnchor, constant: -5),
        
            fullNameCrypto.leadingAnchor.constraint(equalTo: cryptoImage.trailingAnchor, constant: 4),
            fullNameCrypto.topAnchor.constraint(equalTo: cryptoBacground.topAnchor, constant: 5),
            fullNameCrypto.trailingAnchor.constraint(equalTo: cryptoBacground.trailingAnchor, constant: -64),
            
            shortNameCrypto.topAnchor.constraint(equalTo: fullNameCrypto.bottomAnchor),
            shortNameCrypto.leadingAnchor.constraint(equalTo: cryptoImage.trailingAnchor, constant: 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
