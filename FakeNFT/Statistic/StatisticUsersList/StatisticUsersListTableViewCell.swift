//
//  StatisticUsersListTableViewCell.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/15/25.
//
import UIKit
import Kingfisher

final class StatisticUsersListTableViewCell: UITableViewCell {
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .segmentActive
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "stub_avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .segmentActive
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .segmentActive
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .segmentInactive
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let identifier = "StatisticUsersListTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellView)
        contentView.addSubview(placeLabel)
        cellView.addSubview(avatarImage)
        cellView.addSubview(nameLabel)
        cellView.addSubview(nftCountLabel)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            placeLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            placeLabel.trailingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: -8),
            placeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            avatarImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            avatarImage.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 26),
            avatarImage.heightAnchor.constraint(equalToConstant: 28),
            avatarImage.widthAnchor.constraint(equalToConstant: 28),
            
            nftCountLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 26),
            nftCountLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            
            nameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: nftCountLabel.trailingAnchor, constant: -26)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: UsersListModel, place: Int) {
        if let avatarUrl = URL(string: user.avatar) {
            avatarImage.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "stub_avatar"))
        }
        placeLabel.text = String(place)
        nameLabel.text = user.name
        nftCountLabel.text = String(user.nfts.count)
    }
}
