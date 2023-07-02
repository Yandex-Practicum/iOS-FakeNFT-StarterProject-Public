//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import UIKit
import Combine

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: CatalogCellViewModel? {
        didSet {
            viewModel?.$catalogRows
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] rows in
                    self?.updateCell(with: rows)
                }).store(in: &cancellables)
        }
    }

    private lazy var coverImageView: CatalogCustomImageView = {
        let imageView = CatalogCustomImageView(frame: .zero)
        return imageView
    }()
    
    private lazy var quantityLabel: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .ypBlack)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(coverImageView)
        stackView.addArrangedSubview(quantityLabel)
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func loadCover(from stringUrl: String) {
        guard
            let encodedStringUrl = stringUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedStringUrl)
        else {
            return
        }
        
        coverImageView.setImage(from: url)
    }
    
    private func updateCell(with newRow: NftCollections ) {
        loadCover(from: newRow.cover)
        quantityLabel.text = "\(newRow.name) (\(newRow.nfts.count))"
    }
    
}

// MARK: - Ext Constraints
extension CatalogTableViewCell {
    func setupConstraints() {
        setupMainStackView()
    }
    
    func setupMainStackView() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
