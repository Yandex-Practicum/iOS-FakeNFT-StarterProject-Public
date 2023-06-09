//
//  ProfileTableViewCell.swift
//  FakeNFT
//

import UIKit

final class ProfileTableViewCell: UITableViewCell, ReuseIdentifying {

    private lazy var profileOptionlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        accessoryType = .disclosureIndicator
    }

    private func setupConstraints() {
        contentView.addSubview(profileOptionlabel)
        NSLayoutConstraint.activate([
            profileOptionlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            profileOptionlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileOptionlabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func setLabel(text: String) {
        profileOptionlabel.text = text
    }
}
