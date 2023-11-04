//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell {
    
    private let NFTImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cell_stub")
        
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "Hello"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(text: String, counter: Int) {
        descriptionLabel.text = "\(text) (\(counter))"
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
    
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(NFTImageView)
        contentView.addSubview(descriptionLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            NFTImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            NFTImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            NFTImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            NFTImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -27),
            
            descriptionLabel.topAnchor.constraint(equalTo: NFTImageView.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: NFTImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: NFTImageView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
    }
}
