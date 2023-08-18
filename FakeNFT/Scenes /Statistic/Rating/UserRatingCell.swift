//
//  UserRatingCell.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

import UIKit

final class UserRatingCell: UITableViewCell, ReuseIdentifying {
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .YPBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .YPLightGrey
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .YPBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .YPBlack
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(index: Int, user: User?) {
        indexLabel.text = "\(index + 1)"
        nameLabel.text = user?.name
        ratingScoreLabel.text = user?.rating
        
        if let avatarUrl = user?.avatar,
           let avatarUrl = URL(string: avatarUrl) {
            avatarImageView.loadImage(url: avatarUrl, cornerRadius: 100)
        }
    }
    
    private func addViews() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(indexLabel)
        mainStackView.addArrangedSubview(backgroundCardView)
        
        backgroundCardView.addSubview(avatarImageView)
        backgroundCardView.addSubview(nameLabel)
        backgroundCardView.addSubview(ratingScoreLabel)
    }
    
    private func setUpConstraints() {
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingScoreLabel.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            mainStackView.heightAnchor.constraint(equalToConstant: 80),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                        
            backgroundCardView.heightAnchor.constraint(equalToConstant: 80),
            indexLabel.widthAnchor.constraint(equalToConstant: 27),
            
            avatarImageView.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor),
            ratingScoreLabel.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            
            avatarImageView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            ratingScoreLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -16),
            nameLabel.trailingAnchor.constraint(equalTo: ratingScoreLabel.leadingAnchor, constant: -26),
            ratingScoreLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
        
}
