//
//  StatisticsUserNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 24.07.2024.
//

import Foundation
import UIKit

final class StatisticsUserNFTCollectionViewCell : UICollectionViewCell {
    var nftImage = UIImageView()
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
        
    }
    private func setupUI(){
        for subView in [nftImage, heartButton, starsHorizontalStack, bottomContainer] {
            contentView.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func prepareImageContainer(){
         nftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 108, height: 108))
        nftImage.layer.cornerRadius = 12
        nftImage.image = UIImage(systemName: "tortoise")
        
        heartButton = UIButton(frame:CGRect(x: 0, y: 0, width: 40, height: 40))
        heartButton.setImage(Asset.Images.favouritesDone, for: .normal)
    
    }
    private func prepareStarsContainer(){
         starsHorizontalStack
         starImage
    }
    private func prepareBottomContainer(){
        bottomContainer
        nftNameLabel
        nftPriceLabel
        cartButton
    }
    
    func setNFTImage(with newImage: UIImage){
        nftImage.image = newImage
    }
    func setIsLiked(with isLiked : Bool){
        if isLiked {
            //show pink heart
        }else{
            //show gray heart
        }
    }
    
    func setNFTName(with newName : String){
        nftNameLabel.text = newName
    }
    func setNFTRating(with newRating : Int){
        //configure yellows hearts
    }
    func setNFTPrice(with newPrice: Float){
        nftPriceLabel.text = newPrice.description
    }
}
