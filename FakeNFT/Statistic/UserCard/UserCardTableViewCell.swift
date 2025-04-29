//
//  UserCartTableViewCell.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/21/25.
//
import UIKit

final class UserCardTableViewCell: UITableViewCell {
    // MARK: - UI Elements
    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.text = "TEST"
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var customDisclosureIndicator: UIImageView = {
        let customDisclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.forward"))
        customDisclosureIndicator.tintColor = .segmentActive
        customDisclosureIndicator.frame = CGRect(x: 0, y: 0, width: 8, height: 14)
        return customDisclosureIndicator
    }()
    // MARK: - Public Properties
    static let identifier = "UserCardTableViewCell"
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryView = customDisclosureIndicator
        contentView.addSubview(cellLabel)
        NSLayoutConstraint.activate([
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods
    func configure(with user: UsersListModel) {
        cellLabel.text = "Коллекция NFT (\(user.nfts.count))"
    }
}
