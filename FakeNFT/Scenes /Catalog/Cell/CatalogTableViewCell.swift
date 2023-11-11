//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit
import Kingfisher

final class CatalogTableViewCell: UITableViewCell {
    
    //MARK: - Public properties
    var onState: (() -> ())?
    
    //MARK: - Private properties
    private let NFTImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var gradient: GradientView = {
        return GradientView(frame: self.bounds)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NFTImageView.kf.cancelDownloadTask()
    }
    
    //MARK: - Public methods
    func configureCell(model: Catalog) {
        startAnimation()
        
        descriptionLabel.text = "\(model.name) (\(model.nfts.count))"
        
        NFTImageView.kf.setImage(
            with: model.coverURL,
            placeholder: nil,
            completionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.stopAnimation()
                onState?()
            })
    }
    
    //MARK: - Private methods
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
    
        addSubviews()
        applyConstraints()
        
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.isHidden = true
    }
    
    private func addSubviews() {
        contentView.addSubview(NFTImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(gradient)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            NFTImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            NFTImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            NFTImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            NFTImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -27),
            
            gradient.topAnchor.constraint(equalTo: NFTImageView.topAnchor),
            gradient.leadingAnchor.constraint(equalTo: NFTImageView.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: NFTImageView.trailingAnchor),
            gradient.bottomAnchor.constraint(equalTo: NFTImageView.bottomAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: NFTImageView.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: NFTImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: NFTImageView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
        ])
    }
    
    private func startAnimation() {
        gradient.isHidden = false
        gradient.startAnimating()
    }
    
    private func stopAnimation() {
        gradient.stopAnimating()
        gradient.isHidden = true
    }
}
