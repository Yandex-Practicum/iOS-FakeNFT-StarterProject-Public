//
//  StatisticsUserNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 24.07.2024.
//

import Foundation
import UIKit

final class StatisticsUserNFTCollectionViewCell : UICollectionViewCell {
    var nftImageView = UIImageView()
    var heartButton = UIButton(type: .system)
    var starsHorizontalStack = UIStackView()
    var starImage = UIImageView()
    var nftNameLabel = UILabel()
    var nftPriceLabel = UILabel()
    var cartButton = UIButton(type: .system)
    var bottomContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI(){
        prepareImageContainer()
        prepareStarsContainer()
        prepareBottomContainer()
        setupUI()
        activatingConstraints()
    }
    private func setupUI(){
        for subView in [nftImageView, heartButton, starsHorizontalStack, bottomContainer] {
            contentView.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func prepareImageContainer(){
        nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = 12
        nftImageView.image = UIImage(systemName: "tortoise")
        nftImageView.contentMode = .scaleAspectFit
        nftImageView.backgroundColor = .purple.withAlphaComponent(0.035)
        
        
        heartButton = UIButton(frame:CGRect(x: 0, y: 0, width: 40, height: 40))
        heartButton.setImage(Asset.Images.favouritesNoActive, for: .normal)
    }
    private func prepareStarsContainer(){
        starsHorizontalStack.frame = CGRect(x: 0, y: 0, width: 68, height: 12)
        starsHorizontalStack.axis = .horizontal
        starsHorizontalStack.spacing = 2
        
        for _ in 0..<5 {
            let starImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
            starImageView.image = Asset.Images.starDone
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starsHorizontalStack.addArrangedSubview(starImageView)
        }
    }
    private func prepareBottomContainer(){
        bottomContainer.frame = CGRect(x: 0, y: 0, width: 108, height: 40)
        nftNameLabel.font = .bodyBold
        nftNameLabel.textAlignment = .natural
        nftPriceLabel.font = .caption3
        cartButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        cartButton.setImage(Asset.Images.bagCustom, for: .normal)
        cartButton.tintColor = .nftBlack
        
        for subView in [nftNameLabel, nftPriceLabel, cartButton]{
            subView.translatesAutoresizingMaskIntoConstraints = false
            bottomContainer.addSubview(subView)
        }
        
    }
    
    private func activatingConstraints(){
        nftImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(108)
        }
        heartButton.snp.makeConstraints { make in
            make.trailing.equalTo(nftImageView.snp.trailing)
            make.top.equalTo(nftImageView.snp.top)
            make.width.height.equalTo(40)
        
        }
        starsHorizontalStack.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nftImageView.snp.bottom).offset(8)
            make.height.equalTo(12)
            make.width.equalTo(68)
        }
        bottomContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(starsHorizontalStack.snp.bottom).offset(4)
            make.width.equalTo(108)
            make.height.equalTo(40)
        }
        
        nftNameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(bottomContainer)
            make.height.equalTo(22)
            make.width.equalTo(68)
        }
        nftPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nftNameLabel.snp.bottom).offset(4)
        }
        
        cartButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    private func updateStarsRating(with newRating : Int){
        for (index, starView) in starsHorizontalStack.arrangedSubviews.enumerated() {
            guard let starImageView = starView as? UIImageView else { continue }
            if index < newRating {
                starImageView.image = Asset.Images.starDone
            } else {
                starImageView.image = Asset.Images.starNoActive
            }
        }
    }
    func setNFTImage(with newImage: UIImage){
        nftImageView.image = newImage
    }
    func setIsLiked(with isLiked : Bool){
        if isLiked {
            heartButton.setImage(Asset.Images.favouritesDone, for: .normal)
        }else{
            heartButton.setImage(Asset.Images.favouritesNoActive, for: .normal)
        }
    }
    func setNFTName(with newName : String){
        nftNameLabel.text = newName
    }
    func setNFTRating(with newRating : Int){
        updateStarsRating(with: newRating)
    }
    func setNFTPrice(with newPrice: Float){
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = ","
        if let formattedPrice = numberFormatter.string(from: NSNumber(value: newPrice)) {
            nftPriceLabel.text = "\(formattedPrice) ETH"
        } else {
            nftPriceLabel.text = "\(newPrice) ETH"
        }
    }
}
