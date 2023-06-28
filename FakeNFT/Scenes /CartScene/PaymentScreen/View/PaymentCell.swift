//
//  PaymentCell.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 27.06.2023.
//

import UIKit

final class PaymentCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "coloncurrencysign.circle.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let shortName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.11, green: 0.62, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 1
            } else {
                layer.borderWidth = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 36),
            image.widthAnchor.constraint(equalToConstant: 36),
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 4),
            name.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            shortName.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 4),
            shortName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    private func setupProperties() {
        layer.cornerRadius = 12
        addSubview(image)
        addSubview(name)
        addSubview(shortName)
    }
    
    func setBorder() {
        print("SET")
    }
    
}
