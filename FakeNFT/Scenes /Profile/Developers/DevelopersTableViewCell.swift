//
//  DevelopersTableViewCell.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 22.09.2023.
//

import UIKit

final class DevelopersTableViewCell: UITableViewCell {
    static let identifier = "DevelopersTableViewCellIdentifier"
    // MARK: - Properties

    let developersView = DevelopersView()

    // MARK: - Initialiser

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground
        layouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layouts() {
        addSubview(developersView)
        developersView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            developersView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            developersView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            developersView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            developersView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func configure(with developers: Developers) {
        self.developersView.configure(with: developers)
    }
}
