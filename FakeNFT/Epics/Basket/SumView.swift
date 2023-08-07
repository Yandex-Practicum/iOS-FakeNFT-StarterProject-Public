//
//  Sum.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 02/08/2023.
//

import UIKit

final class SumView: UIView {
        
    private let button: Button = {
        let button = Button(title: "К оплате")
        return button
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = UIColor.ypBlackUniversal
        label.text = "3 NFT"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor.ypGreenUniversal
        label.text = "5,34 ETH"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SumView {
    
    func setupView() {
        backgroundColor = UIColor.ypLightGrayDay
        layer.cornerRadius = 16
        
        [button, labelsStack]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        addSubview(button)
        addSubview(labelsStack)
        labelsStack.addArrangedSubview(countLabel)
        labelsStack.addArrangedSubview(priceLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            button.leadingAnchor.constraint(equalTo: labelsStack.trailingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: labelsStack.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
