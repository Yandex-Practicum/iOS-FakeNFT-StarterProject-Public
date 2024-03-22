//
//  File.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 22.03.2024.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func deleteButtonTapped(at indexPath: IndexPath)
}

class CartCustomCell: UITableViewCell {
    
    weak var delegate: CartCellDelegate?
    
    var indexPath: IndexPath?
    
    private lazy var nftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "1-1")
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nftName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "April"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stars: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "star.fill")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        return imageView
    }()
    
    private lazy var starsStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(stars)
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nftNameAndRaitingStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(nftName)
        stack.addArrangedSubview(starsStack)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nftLabelAndPriceStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(nftPriceLabel)
        stack.addArrangedSubview(nftPrice)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nftPriceLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "Цена"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftPrice: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "1,78 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteNftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Delete"), for: .normal)
        button.addTarget(self, action: #selector(deleteNFT), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func deleteNFT() {
        guard let indexPath = indexPath else { return }
        delegate?.deleteButtonTapped(at: indexPath)
        print("DELETE")
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAllViews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAllViews()
    }
    
    private func setupAllViews() {
        contentView.addSubview(nftView)
        nftView.addSubview(nftImage)
        nftView.addSubview(nftNameAndRaitingStack)
        nftView.addSubview(nftLabelAndPriceStack)
        nftView.addSubview(deleteNftButton)
        
        NSLayoutConstraint.activate([
            nftView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            nftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nftImage.topAnchor.constraint(equalTo: nftView.topAnchor, constant: 16),
            nftImage.leadingAnchor.constraint(equalTo: nftView.leadingAnchor, constant: 16),
            nftImage.bottomAnchor.constraint(equalTo: nftView.bottomAnchor, constant: -16),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            
            nftNameAndRaitingStack.topAnchor.constraint(equalTo: nftView.topAnchor, constant: 24),
            nftNameAndRaitingStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            nftNameAndRaitingStack.trailingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: -147),
            
            nftLabelAndPriceStack.topAnchor.constraint(equalTo: nftNameAndRaitingStack.bottomAnchor, constant: 12),
            nftLabelAndPriceStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            nftLabelAndPriceStack.trailingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: -147),
            
            deleteNftButton.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            deleteNftButton.trailingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: -16),
            deleteNftButton.widthAnchor.constraint(equalToConstant: 40),
            deleteNftButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}


