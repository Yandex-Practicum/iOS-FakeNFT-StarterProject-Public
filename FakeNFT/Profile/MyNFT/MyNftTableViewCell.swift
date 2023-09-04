//
//  MyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

final class MyNftTableViewCell: UITableViewCell {
    static let identifier = "MyNftTableViewCellidentifier"
    
    let avatarView = NftAvatarView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let ratingView = RatingView()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    
    
    
}
