//
//  CryptoCellView.swift
//  FakeNFT
//
//  Created by Кирилл Дробин on 24.03.2025.
//

import UIKit
import Kingfisher

final class CryptoCellView: UICollectionViewCell {
    // MARK: - Private Properties
    private lazy var cryptoIcon: UIImageView = {
        let cryptoIcon = UIImageView()
        cryptoIcon.layer.cornerRadius = 6
        cryptoIcon.layer.backgroundColor = UIColor.black.cgColor
        return cryptoIcon
    }()

    private lazy var cryptoName: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        name.textColor = UIColor(named: "blackForDarkMode")
        return name
    }()
    
    private lazy var cryptoNameShort: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        name.textColor = UIColor(red: 28/255, green: 159/255, blue: 0/255, alpha: 1)
        return name
    }()
        
    // MARK: - Cell init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "greyForDarkMode")
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [
            cryptoIcon,
            cryptoName,
            cryptoNameShort
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            cryptoIcon.heightAnchor.constraint(equalToConstant: 36),
            cryptoIcon.widthAnchor.constraint(equalToConstant: 36),
            cryptoIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cryptoIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            cryptoName.heightAnchor.constraint(equalToConstant: 18),
            cryptoName.widthAnchor.constraint(equalToConstant: 90),
            cryptoName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cryptoName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            
            cryptoNameShort.heightAnchor.constraint(equalToConstant: 18),
            cryptoNameShort.widthAnchor.constraint(equalToConstant: 70),
            cryptoNameShort.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            cryptoNameShort.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            
        ])
    }
    
    // MARK: - Public Methods
    func cellSetup(imageUrl: URL, name: String, shortName: String) {
        contentView.layer.cornerRadius = 12
        cryptoIcon.kf.setImage(with: imageUrl)
        cryptoName.text = name
        cryptoNameShort.text = shortName
        
    }
}
