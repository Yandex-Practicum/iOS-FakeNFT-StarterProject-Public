//
//  ProfileVCTableViewCell.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 03.09.2023.
//

import UIKit

final class ProfileVCTableViewCell: UITableViewCell {
    static let identifier = "ProfileVCTableViewCellIdentifier"

    private  let cellTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .label
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground

        layouts()
    }

     func configureCell(text: String) {
        cellTitleLabel.text = text

    }

    private func layouts() {
        [cellTitleLabel, arrowImage].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        NSLayoutConstraint.activate([
            cellTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
