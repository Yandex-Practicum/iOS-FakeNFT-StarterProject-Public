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
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cryptoImage: UIImageView = {
        let image = UIImage(named: "Bitcoin (BTC)")
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cryptoBacground)
        cryptoBacground.addSubview(cryptoImage)
        
        NSLayoutConstraint.activate([
            cryptoBacground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cryptoBacground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cryptoBacground.topAnchor.constraint(equalTo: contentView.topAnchor),
            cryptoBacground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
            cryptoImage.leadingAnchor.constraint(equalTo: cryptoBacground.leadingAnchor, constant: 12),
            cryptoImage.topAnchor.constraint(equalTo: cryptoBacground.topAnchor, constant: 5),
            cryptoImage.bottomAnchor.constraint(equalTo: cryptoBacground.bottomAnchor, constant: 5)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
