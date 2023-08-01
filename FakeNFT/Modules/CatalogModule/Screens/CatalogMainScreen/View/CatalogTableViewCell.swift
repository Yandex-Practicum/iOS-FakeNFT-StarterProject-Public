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

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var quantityLabel: CustomLabel = {
        let label = CustomLabel(size: 17, weight: .bold, color: .ypBlack)
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.contentMode = .topLeft
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 6)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(coverImageView)
        stackView.addArrangedSubview(quantityLabel)
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func updateCell(with newRow: CatalogMainScreenCollection ) {
        loadCover(from: newRow.cover)
        quantityLabel.text = "\(newRow.name) (\(newRow.nfts.count))"
    }
    
}

// MARK: - Ext Constraints
private extension CatalogTableViewCell {
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
