//
//  CollectionNFTCell.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 13.12.2023.
//

import UIKit

final class CollectionNFTCell: UICollectionViewCell, ReuseIdentifying {
    
    private lazy var imageView: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "Cover Collection")
        img.layer.cornerRadius = 12
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Favourites icons"), for: .normal)
        return btn
    }()
    
    //Вью с рейтингом
    
    private lazy var nameNFTLabel: UILabel = {
       let label = UILabel()
        label.text = "Archie"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
         label.text = "1 ETH"
         label.font = .systemFont(ofSize: 10, weight: .medium)
         return label
     }()
    
    private lazy var basketButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Cart"), for: .normal)
         return btn
    }()
    
    private lazy var stackViewDescription: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configUI(){
        [imageView, likeButton, stackViewDescription, basketButton].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [nameNFTLabel , priceLabel].forEach{
            stackViewDescription.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            
            stackViewDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            stackViewDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackViewDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackViewDescription.heightAnchor.constraint(equalToConstant: 40),
            
            basketButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            basketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basketButton.heightAnchor.constraint(equalToConstant: 40),
            basketButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func config(with model: CollectionNFTCellViewModel){
        nameNFTLabel.text = model.nameNFT
        priceLabel.text = model.price + " ETH"
        //
        basketButton.setImage(setBasket(isInTheBasket: model.isInTheBasket), for: .normal)
        likeButton.setImage(setLike(isLiked: model.isLiked), for: .normal)
    }
    
    func setLike(isLiked: Bool) -> UIImage? {
        isLiked ? UIImage(named: "Favourites icons") : UIImage(named: "Favourites icons")
    }
    
    func setBasket(isInTheBasket: Bool) -> UIImage? {
        isInTheBasket ? UIImage(named: "Cart") : UIImage(named: "Cart")
    }
    
}
