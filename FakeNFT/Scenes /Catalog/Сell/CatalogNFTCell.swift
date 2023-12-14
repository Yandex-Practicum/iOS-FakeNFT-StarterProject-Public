//
//  CatalogNFTCell.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 12.12.2023.
//

import UIKit

final class CatalogNFTCell: UITableViewCell, ReuseIdentifying {
    
    private var imagePreview: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Cover Collection")
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    let stackViewLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    
    private var nameNFT: UILabel = {
        let label = UILabel()
        label.text = "Peach"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private var countNFT: UILabel = {
        let label = UILabel()
        label.text = "(11)"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private var spacerView: UIView = {
       let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    
    // MARK: - Initialization
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    // MARK: - Functions
    
    func config(){
        [imagePreview,stackViewLabel].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [nameNFT, countNFT, spacerView].forEach{
            stackViewLabel.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
      
        NSLayoutConstraint.activate([
            imagePreview.heightAnchor.constraint(equalToConstant: 140),
            imagePreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imagePreview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imagePreview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            
            stackViewLabel.heightAnchor.constraint(equalToConstant: 22),
            stackViewLabel.topAnchor.constraint(equalTo: imagePreview.bottomAnchor, constant: 4),
            stackViewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            stackViewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackViewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        
    }
    
    func setImage(image: UIImage){
        imagePreview.image = image
    }
   
}
