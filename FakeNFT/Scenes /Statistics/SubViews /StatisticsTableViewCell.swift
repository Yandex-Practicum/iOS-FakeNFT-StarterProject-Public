//
//  StatisticsTableViewCell.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 19.07.2024.
//

import Foundation
import UIKit
import SnapKit

final class StatisticsTableViewCell: UITableViewCell {
    
    private var userAvatarImageView = UIImageView()
    private var userNameLabel = UILabel()
    private var nftAmountLabel = UILabel()
    private var cellIndex = UILabel()
    private let horizontalContainer = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .background
        self.layer.cornerRadius = 14
        prepareUserNameLabel()
        prepareNFTAmonuntLabel()
        prepareUserAvatarImageView()
        prepareCellIndexLabel()
        prepareContainer()
        setupUI()
        activatingConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        for subView in [horizontalContainer, userAvatarImageView, userNameLabel, nftAmountLabel, cellIndex] {
            contentView.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
    }
    private func activatingConstraints() {
        cellIndex.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(27)
        }
        
        horizontalContainer.snp.makeConstraints { make in
            make.leading.equalTo(cellIndex.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        userAvatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(horizontalContainer.snp.leading).offset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(28)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userAvatarImageView.snp.trailing).offset(8)
            make.centerY.equalTo(userAvatarImageView)
            make.trailing.lessThanOrEqualTo(nftAmountLabel.snp.leading).offset(-8)
        }
        
        nftAmountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(horizontalContainer.snp.trailing).inset(16)
            make.leading.greaterThanOrEqualTo(userNameLabel.snp.trailing).offset(23)
            make.centerY.equalTo(userAvatarImageView)
            make.height.equalTo(28)
            make.width.equalTo(31)
        }
    }
    
    
    private func prepareUserAvatarImageView() {
        userAvatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        userAvatarImageView.layer.cornerRadius = 14
        userAvatarImageView.clipsToBounds = true
        userAvatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
    }
    private func prepareUserNameLabel() {
        
        userNameLabel.textAlignment = .natural
        userNameLabel.font = .headline3
        userNameLabel.textColor = .nftBlack
        userNameLabel.lineBreakMode = .byTruncatingTail
    }
    private func prepareNFTAmonuntLabel() {
        nftAmountLabel.textAlignment = .center
        nftAmountLabel.font = .headline3
        nftAmountLabel.textColor = .nftBlack
    }
    private func prepareCellIndexLabel() {
        cellIndex.textAlignment = .center
        cellIndex.font = .caption1
        cellIndex.textColor = .nftBlack
    }
    private func prepareContainer() {
        horizontalContainer.layer.cornerRadius = 12
        horizontalContainer.backgroundColor = .segmentInactive
    }
    
    func setUserName(with newName: String){
        userNameLabel.text = newName
    }

    func setUserCollectionAmount(with newAmout: String){
        nftAmountLabel.text = newAmout
    }
    
    func setCellIndex(with newValue : Int){
        cellIndex.text = newValue.description
    }
    
    func setUserImage(with userImageURL: String) {
        let placeholderImage = UIImage(systemName: "person.crop.circle.fill")
        userAvatarImageView.image = placeholderImage
        userAvatarImageView.tintColor = .nftPlaceHolderGray

        if let url = URL(string: userImageURL) {
            userAvatarImageView.loadImage(from: url, placeholder: placeholderImage)
        }
    }
}
