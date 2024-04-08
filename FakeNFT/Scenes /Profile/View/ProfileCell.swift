//
//  ProfileCell.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 04.04.2024.
//

import Foundation
import UIKit

final class ProfileCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let cellID = "ProfileCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.text = "Мой NFT"
        label.font = UIFont.sfProBold17
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypBlack")
        label.text = "(112)"
        label.font = UIFont.sfProBold17
        return label
    }()
    
    lazy var imageCheck: UIImageView = {
        let imVi = UIImageView()
        imVi.image = UIImage(systemName: "chevron.right")
        imVi.contentMode = .scaleAspectFit
        imVi.tintColor = UIColor(named: "ypBlack")
        return imVi
    }()
    
    // MARK: - Initializers
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func changingLabels(nameView: String, numberView: String) {
        nameLabel.text = nameView
        numberLabel.text = numberView
    }
 
    // MARK: - Private Methods
    private func customizingScreenElements() {
        [nameLabel, numberLabel, imageCheck].forEach {contentView.addSubview($0)}
    }
    
    private func customizingTheLayoutOfScreenElements() {
        [nameLabel, numberLabel, imageCheck].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            numberLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            imageCheck.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageCheck.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
