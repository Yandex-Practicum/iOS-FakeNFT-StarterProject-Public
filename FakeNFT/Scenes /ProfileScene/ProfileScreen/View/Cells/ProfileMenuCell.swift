//
//  ProfileMenuCell.swift
//  FakeNFT
//
//  Created by Илья Валито on 19.06.2023.
//

import UIKit

// MARK: - ProfileMenuCell
final class ProfileMenuCell: UITableViewCell {

    // MARK: - Properties and Initializers
    let menuCategoryLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.bold, withSize: 17))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Helpers
extension ProfileMenuCell {

    private func setupAutolayout() {
        menuCategoryLabel.toAutolayout()
    }

    private func addSubviews() {
        addSubview(menuCategoryLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            menuCategoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            menuCategoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            menuCategoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            menuCategoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
