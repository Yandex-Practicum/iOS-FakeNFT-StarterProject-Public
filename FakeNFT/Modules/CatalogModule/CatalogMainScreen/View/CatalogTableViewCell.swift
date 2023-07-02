//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {

    private lazy var leftImageView: CatalogCustomImageView = {
        let imageView = CatalogCustomImageView(frame: .zero)
        return imageView
    }()
    
    private lazy var centerImageView: UIImageView = {
        let imageView = CatalogCustomImageView(frame: .zero)
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = CatalogCustomImageView(frame: .zero)
        return imageView
    }()
}
