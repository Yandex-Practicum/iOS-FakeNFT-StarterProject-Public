//
//  PayCell.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 07.05.2024.
//

import Foundation
import UIKit
import Kingfisher

final class PayCell: UICollectionViewCell {
    
    static let identifier = "PayCell"
    private (set) var currency: CurrencyDataModel?
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor(named: "LightGray")
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 12
        cardView.layer.borderColor = UIColor(named: "Black")?.cgColor
        return cardView
    }()
    
    lazy var backView: UIImageView = {
       let  backView = UIImageView()
        backView.layer.cornerRadius = 6
        backView.layer.backgroundColor = UIColor(named: "Black")?.cgColor
        backView.translatesAutoresizingMaskIntoConstraints = false
       return  backView
   }()
 
     lazy var moneyImageView: UIImageView = {
        let  moneyImageView = UIImageView()
    //    moneyImageView.image = UIImage(named: "Bitcoin (BTC)")
         moneyImageView.translatesAutoresizingMaskIntoConstraints = false
        return  moneyImageView
    }()
    
     lazy var moneyNameLabel: UILabel = {
        let moneyNameLabel = UILabel()
   //     moneyNameLabel.text = "Bitcoin"
        moneyNameLabel.font = .caption2
        moneyNameLabel.textColor = UIColor(named: "Black")
        moneyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return moneyNameLabel
    }()
    
     lazy var moneyShotLabel: UILabel = {
        let moneyShotLabel = UILabel()
        moneyShotLabel.font = .caption2
    //    moneyShotLabel.text = "ВТС"
        moneyShotLabel.textColor = UIColor(named: "Green")
        moneyShotLabel.translatesAutoresizingMaskIntoConstraints = false
        return moneyShotLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout()
        setupLayoutPayView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private  func addSubviews() {
        contentView.addSubview(cardView)
        self.clipsToBounds = true
        cardView.addSubview(backView)
        backView.addSubview(moneyImageView)
        cardView.addSubview(moneyNameLabel)
        cardView.addSubview(moneyShotLabel)
    }
        
    private func setupLayoutPayView() {
        NSLayoutConstraint.activate([
            
            backView.heightAnchor.constraint(equalToConstant: 36),
            backView.widthAnchor.constraint(equalToConstant: 36),
            backView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 5),
            backView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            moneyImageView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            moneyImageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            
            moneyNameLabel.leadingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 4),
            moneyNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 5),
            
            moneyShotLabel.leadingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 4),
            moneyShotLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -5),
            
        ])
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            cardView.heightAnchor.constraint(equalToConstant: 46),
            cardView.widthAnchor.constraint(equalToConstant: 168),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func updateCell(currency: CurrencyDataModel) {
        self.currency = currency
        
        var image: UIImage
        if UIImage(named: currency.image) == nil {
            image = UIImage(named: "NFTcard")!
        } else {
            image = UIImage(named: currency.image)!
        }
        moneyImageView.image = image
        
        moneyNameLabel.text = currency.title
        moneyShotLabel.text = currency.name
    }
    
    func selectCell(wasSelected: Bool) {
        cardView.layer.borderWidth = wasSelected ? 1 : 0
        cardView.layer.borderColor = UIColor(named: "Black")?.cgColor
    }
}
