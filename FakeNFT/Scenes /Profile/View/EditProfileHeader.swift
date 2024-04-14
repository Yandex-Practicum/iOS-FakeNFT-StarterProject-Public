//
//  EditProfileHeader.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 14.04.2024.
//

import Foundation
import UIKit

final class EditProfileHeader: UICollectionReusableView {
    // MARK: - Public Properties
    static let headerID = "EditProfileHeader"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProBold22
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
