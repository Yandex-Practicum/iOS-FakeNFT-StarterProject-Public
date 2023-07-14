//
//  CartPaymentMethodCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import UIKit
import Combine

final class CartPaymentMethodCell: UICollectionViewCell, ReuseIdentifying {
    
    private var cancellables = Set<AnyCancellable>() 
        
    var viewModel: PaymentMethodCellViewModel? {
        didSet {
            viewModel?.$paymentMethodRow
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] paymentMethod in
                    self?.updateCell(with: paymentMethod)
                })
                .store(in: &cancellables)
        }
    }
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return imageView
    }()
    
    private lazy var coinNameLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .ypBlack)
        return label
    }()
    
    private lazy var coinCodeLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .universalGreen)
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        
        let labelStackView = UIStackView(arrangedSubviews: [coinNameLabel, coinCodeLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        
        stackView.addArrangedSubview(coinImageView)
        stackView.addArrangedSubview(labelStackView)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .ypLightGrey
        layer.cornerRadius = 12
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.forEach({ $0.cancel() })
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? selectCell() : deselectCell()
        }
    }
    
    private func updateCell(with data: PaymentMethodRow) {
        loadCover(from: data.image)
        coinNameLabel.text = data.title
        coinCodeLabel.text = data.name
    }
    
    private func loadCover(from stringUrl: String?) {
        guard let url = viewModel?.createUrl(from: stringUrl) else { return }
        coinImageView.setImage(from: url)
    }
    
    private func selectCell() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.ypBlack?.cgColor
    }
    
    private func deselectCell() {
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
}

// MARK: - Ext Constraints
extension CartPaymentMethodCell {
    func setupConstraints() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
