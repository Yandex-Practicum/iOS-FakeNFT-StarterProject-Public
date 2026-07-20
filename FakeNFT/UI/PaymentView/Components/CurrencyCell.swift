//
//  CarrencyCell.swift
//  FakeNFT
//
//  Created by Сергей Петров on 20.07.2026.
//
import UIKit

// MARK: - CurrencyCell
final class CurrencyCell: UIView {
    
    // MARK: - Properties
    private var onTap: ((Currency) -> Void)?
    private var currentCurrency: Currency?
    
    // MARK: - UI Elements
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "yaBlack") ?? .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "uniGreen") ?? .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor(named: "yaLightGrey") ?? .secondarySystemBackground
        layer.cornerRadius = 12
        clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(nameLabel)
        
        mainStackView.addArrangedSubview(currencyImageView)
        mainStackView.addArrangedSubview(textStackView)
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            currencyImageView.widthAnchor.constraint(equalToConstant: 32),
            currencyImageView.heightAnchor.constraint(equalToConstant: 32),
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    func configure(with currency: Currency, isSelected: Bool, onTap: @escaping (Currency) -> Void) {
        self.currentCurrency = currency
        self.onTap = onTap
        
        titleLabel.text = currency.title
        nameLabel.text = currency.name

        loadImage(from: currency.image)

        layer.borderWidth = isSelected ? 1 : 0
        layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
    }
    
    // MARK: - Image Loading
    private func loadImage(from urlString: String) {
        currencyImageView.image = nil
        
        if let url = URL(string: urlString),
           (url.scheme == "http" || url.scheme == "https") {
            
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let image = UIImage(data: data)
                    
                    Task { @MainActor in
                        if self.currentCurrency?.image == urlString {
                            self.currencyImageView.image = image
                        }
                    }
                } catch {
                    Task { @MainActor in
                        if self.currentCurrency?.image == urlString {
                            self.currencyImageView.image = UIImage(systemName: "exclamationmark.triangle")
                        }
                    }
                }
            }
        } else {
            currencyImageView.image = UIImage(named: urlString)
        }
    }
    
    // MARK: - Actions
    @objc private func cellTapped() {
        guard let currency = currentCurrency else { return }
        onTap?(currency)
    }
}
