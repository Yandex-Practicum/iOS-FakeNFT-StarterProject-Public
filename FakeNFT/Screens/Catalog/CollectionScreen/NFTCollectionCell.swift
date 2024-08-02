//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import UIKit
import SnapKit

// MARK: - Protocol

protocol NFTCollectionCellDelegate: AnyObject {
    func onLikeButtonTapped(cell: NFTCollectionCell)
    func addToCartButtonTapped(cell: NFTCollectionCell)
}

// MARK: - Final Class

final class NFTCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    private var nftModel: Nft?
    var presenter: CatalogСollectionPresenterProtocol?
    
    weak var delegate: NFTCollectionCellDelegate?
    
    private lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .red
        button.addTarget(self, action: #selector(userDidLike), for: .touchUpInside)
        button.setImage(UIImage(named: "likeNotActive"), for: .normal)
        
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .black
        button.setImage(UIImage(named: "addToCart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(cartItemAdded), for: .touchUpInside)
        return button
    }()
    
    private lazy var ratingStarsView: DynamicRatingView = {
        let view = DynamicRatingView()
        return view
    }()
    
    private lazy var nftNameAndPriceView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var nftName: UILabel = {
        let label = UILabel()
        label.text = "nftName"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var nftPrice: UILabel = {
        let label = UILabel()
        label.text = "1 ETH"
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    override init(frame: CGRect ) {
        super.init(frame: frame)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    private func setupCellUI() {
        [nftImage, likeButton, ratingStarsView, cartButton, nftNameAndPriceView].forEach {
            contentView.addSubview($0)
        }
        [nftName, nftPrice].forEach {
            nftNameAndPriceView.addSubview($0)
        }
        
        nftImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(108)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(nftImage.snp.top)
            make.trailing.equalTo(nftImage.snp.trailing)
            make.size.equalTo(42)
        }
        
        ratingStarsView.snp.makeConstraints { make in
            make.top.equalTo(nftImage.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading)
            make.height.equalTo(12)
            make.width.equalTo(68)
        }
        
        nftNameAndPriceView.snp.makeConstraints { make in
            make.top.equalTo(ratingStarsView.snp.bottom).offset(4)
            make.leading.equalTo(contentView.snp.leading)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.63)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        nftName.snp.makeConstraints { make in
            make.top.equalTo(nftNameAndPriceView.snp.top)
            make.leading.equalTo(nftNameAndPriceView.snp.leading)
            make.trailing.lessThanOrEqualTo(nftNameAndPriceView.snp.trailing)
        }
        
        nftPrice.snp.makeConstraints { make in
            make.bottom.equalTo(nftNameAndPriceView.snp.bottom)
            make.leading.equalTo(nftNameAndPriceView.snp.leading)
            make.trailing.lessThanOrEqualTo(nftNameAndPriceView.snp.trailing)
        }
        
        cartButton.snp.makeConstraints { make in
            make.centerY.equalTo(nftNameAndPriceView.snp.centerY)
            make.leading.greaterThanOrEqualTo(nftNameAndPriceView.snp.trailing)
            make.trailing.equalTo(contentView.snp.trailing)
            make.size.equalTo(40)
        }
    }
    
    func setNftModel(_ model: Nft?) {
        nftModel = model
    }
    
    func getNftModel() -> Nft? {
        return nftModel
    }
    
    func renderCellForModel() {
        guard let nftModel = nftModel else { return }
        
        if let imageURL = nftModel.images.first {
            nftImage.kf.setImage(with: imageURL)
        }
        
        nftName.text = nftModel.name
        nftPrice.text = "\(nftModel.price) ETH"
        ratingStarsView.configureRating(nftModel.rating)
        updateCartButtonImage()
        updateLikeButtonImage()
    }
    
    private func configureLikeButtonImage(_ isAlreadyLiked: Bool) {
        let likeName = isAlreadyLiked ? "likeActive" : "likeNotActive"
        likeButton.setImage(UIImage(named: likeName), for: .normal)
    }
    
    private func configureCartButtonImage(_ isAlreadyInCart: Bool) {
        let cartImage = isAlreadyInCart ? "deleteFromCart" : "addToCart"
        cartButton.setImage(UIImage(named: cartImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func updateLikeButtonImage() {
        guard let nftModel = nftModel else { return }
        let isAlreadyLiked = presenter?.isAlreadyLiked(nftId: nftModel.id) ?? false
        configureLikeButtonImage(isAlreadyLiked)
    }
    
    func updateCartButtonImage() {
        guard let nftModel = nftModel else { return }
        let isAlreadyInCart = presenter?.isAlreadyInCart(nftId: nftModel.id) ?? false
        configureCartButtonImage(isAlreadyInCart)
    }
    
    // MARK: - @objc func
    
    @objc func userDidLike() {
        updateLikeButtonImage()
        delegate?.onLikeButtonTapped(cell: self)
    }
    
    @objc func cartItemAdded() {
        updateCartButtonImage()
        delegate?.addToCartButtonTapped(cell: self)
    }
}

