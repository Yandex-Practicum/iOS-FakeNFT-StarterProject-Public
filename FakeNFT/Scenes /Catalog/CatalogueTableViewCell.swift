//
//  CatalogueTableViewCell.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 09.09.2024.
//

import Foundation
import UIKit

final class CatalogueTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CatalogueTableViewCell"
    
    private let coverOfSection: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.isHidden = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(coverOfSection)
        NSLayoutConstraint.activate([
            coverOfSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverOfSection.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverOfSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverOfSection.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverOfSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
    }
    
    func configueCover(image: UIImage) {
        coverOfSection.image = image
    }
}
