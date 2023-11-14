//
//  CatalogView.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import UIKit

final class CatalogCollectionView: UIView {
    //stub to check screen presentation from Catalog screen
    //TODO implement the rest of the logic in the next third of epic after the first review
    private let collectionCoverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "cell_stub")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        addSubview(collectionCoverImageView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            collectionCoverImageView.topAnchor.constraint(equalTo: topAnchor),
            collectionCoverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionCoverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionCoverImageView.heightAnchor.constraint(equalToConstant: 310)
        ])
    }
}
