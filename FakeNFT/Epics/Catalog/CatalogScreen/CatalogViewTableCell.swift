//
//  CatalogTableCell.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 03.08.2023.
//

import UIKit
import Kingfisher

final class CatalogViewTableCell: UITableViewCell, ReuseIdentifying {
    private let nftCollectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let nftCollectionImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .top
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftCollectionLabel.text = ""
        nftCollectionImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNftCollectionLabel(collectionName: String, collectionCount: Int) {
        nftCollectionLabel.text = "\(collectionName) (\(collectionCount))"
    }
    
    func setImage(link: String) {
        let url = URL(string: link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        nftCollectionImage.kf.setImage(with: url) { [weak self] _ in
            // MARK: уменьшаю картинку в 4 раза
            if let originalImage = self?.nftCollectionImage.image {
                let scaledSize = CGSize(width: originalImage.size.width / 4, height: originalImage.size.height / 4)
                
                UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
                originalImage.draw(in: CGRect(origin: .zero, size: scaledSize))
                let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                self?.nftCollectionImage.image = scaledImage
            }
        }
    }
    
    private func setView() {
        contentView.backgroundColor = .ypWhite
        contentView.addSubview(nftCollectionImage)
        contentView.addSubview(nftCollectionLabel)
        NSLayoutConstraint.activate([
            nftCollectionImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            nftCollectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCollectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftCollectionImage.heightAnchor.constraint(equalToConstant: 140),
            
            nftCollectionLabel.topAnchor.constraint(equalTo: nftCollectionImage.bottomAnchor, constant: 4),
            nftCollectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCollectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
