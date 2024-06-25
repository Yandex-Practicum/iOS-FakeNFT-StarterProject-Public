//
//  CartCell.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import UIKit

final class CartCell: UITableViewCell, ReuseIdentifying {
    static var defaultReuseIdentifier: String = "CartCell"
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
