//
//  CartCell.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//

import UIKit

// MARK: - CartCell
final class CartCell: UITableViewCell {
    
    static let reuseID = "CartCell"
    
    private enum SizeConstants {
        static let imageSize: CGFloat = 108
        static let imageCornerRadius: CGFloat = 12
        static let cellPadding: CGFloat = 16
        static let starSize: CGFloat = 16
        static let iconSize: CGFloat = 24
    }
    
    // MARK: - UI Elements
    
    // Аналог HStack(spacing: 20)
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // Аналог .scaledToFill()
        imageView.clipsToBounds = true           // Аналог .clipped()
        imageView.layer.cornerRadius = SizeConstants.imageCornerRadius
        imageView.backgroundColor = .systemGray5 // Заглушка во время загрузки
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Аналог VStack(alignment: .leading, spacing: 0)
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold) // Аналог UIFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Price", comment: "Цена")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular) // Аналог UIFont.regular13
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Используем UIButton вместо UIImageView для корректной обработки тапов и доступности
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: SizeConstants.iconSize, weight: .medium)
        // Если у тебя есть кастомная иконка "cartOn", замени "trash.circle.fill" на "cartOn"
        button.setImage(UIImage(systemName: "trash.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .segmentActiveFallback // См. extension ниже
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - State
    private var starImageViews: [UIImageView] = []
    private var currentItem: CartItem?
    private var onDelete: ((CartItem) -> Void)?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupCellUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // 1. Создаем 5 звездочек
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(named: "star") ?? UIImage(systemName: "star.fill"))
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = .systemGray3 // Дефолтный цвет до конфигурации
            starImageView.widthAnchor.constraint(equalToConstant: SizeConstants.starSize).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: SizeConstants.starSize).isActive = true
            starsStackView.addArrangedSubview(starImageView)
            starImageViews.append(starImageView)
        }
        
        // 2. Собираем infoSection (VStack)
        infoStackView.addArrangedSubview(nameLabel)
        
        // Spacer 6pt
        let nameBottomSpacer = UIView()
        nameBottomSpacer.heightAnchor.constraint(equalToConstant: 6).isActive = true
        infoStackView.addArrangedSubview(nameBottomSpacer)
        
        infoStackView.addArrangedSubview(starsStackView)
        
        // Spacer 14pt
        let starsBottomSpacer = UIView()
        starsBottomSpacer.heightAnchor.constraint(equalToConstant: 14).isActive = true
        infoStackView.addArrangedSubview(starsBottomSpacer)
        
        infoStackView.addArrangedSubview(priceTitleLabel)
        
        // Spacer 4pt
        let priceTitleBottomSpacer = UIView()
        priceTitleBottomSpacer.heightAnchor.constraint(equalToConstant: 4).isActive = true
        infoStackView.addArrangedSubview(priceTitleBottomSpacer)
        
        infoStackView.addArrangedSubview(priceValueLabel)
        
        // 3. Собираем главный HStack
        mainStackView.addArrangedSubview(nftImageView)
        mainStackView.addArrangedSubview(infoStackView)
        mainStackView.addArrangedSubview(deleteButton)
        
        // Аналог Spacer() в SwiftUI: заставляем infoSection занимать всё свободное место
        infoStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        infoStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // 4. Добавляем на contentView
        contentView.addSubview(mainStackView)
        
        // 5. Констрейнты
        NSLayoutConstraint.activate([
            // Фиксируем размеры картинки
            nftImageView.widthAnchor.constraint(equalToConstant: SizeConstants.imageSize),
            nftImageView.heightAnchor.constraint(equalToConstant: SizeConstants.imageSize),
            
            // Фиксируем размер кнопки удаления
            deleteButton.widthAnchor.constraint(equalToConstant: SizeConstants.iconSize),
            deleteButton.heightAnchor.constraint(equalToConstant: SizeConstants.iconSize),
            
            // Пиним главный стек к contentView с отступами 16 (аналог .padding(16))
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SizeConstants.cellPadding),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SizeConstants.cellPadding),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SizeConstants.cellPadding),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SizeConstants.cellPadding)
        ])
    }
    
    // MARK: - Configuration
    func configure(with item: CartItem, onDelete: @escaping (CartItem) -> Void) {
        self.currentItem = item
        self.onDelete = onDelete
        
        nameLabel.text = item.name
        priceValueLabel.text = String(format: "%.2f ETH", item.price)
        
        // Загрузка картинки
        loadImage(from: item.imageURL)
        
        // Цвета из твоего ТЗ (с фоллбэком на системные, если extension еще не добавлен)
        let activeTextColor = UIColor.segmentActiveFallback
        let activeStarColor = UIColor.systemYellow
        let inactiveStarColor = UIColor.segmentInactiveFallback
        
        nameLabel.textColor = activeTextColor
        priceTitleLabel.textColor = activeTextColor
        priceValueLabel.textColor = activeTextColor
        
        // Обновляем цвет звездочек (аналог логики в ForEach)
        for (index, starView) in starImageViews.enumerated() {
            starView.tintColor = index < item.rating ? activeStarColor : inactiveStarColor
        }
        
        // Настраиваем действие кнопки удаления
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    @objc private func deleteTapped() {
        guard let item = currentItem else { return }
        onDelete?(item)
    }
    
    // MARK: - Image Loading
    private func loadImage(from urlString: String) {
        // Сбрасываем картинку на заглушку перед новой загрузкой (важно для переиспользования ячеек)
        nftImageView.image = nil
        
        guard let url = URL(string: urlString) else {
            nftImageView.image = UIImage(systemName: "photo")
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let image = UIImage(data: data)
                
                Task { @MainActor in
                    // Проверяем, что ячейка все еще показывает тот же элемент
                    if self.currentItem?.imageURL == urlString {
                        self.nftImageView.image = image
                    }
                }
            } catch {
                Task { @MainActor in
                    if self.currentItem?.imageURL == urlString {
                        self.nftImageView.image = UIImage(systemName: "exclamationmark.triangle")
                    }
                }
            }
        }
    }
}

// MARK: - UIColor Fallbacks
extension UIColor {
    static var segmentActiveFallback: UIColor {
        // Попытка взять кастомный цвет, если его нет - берем системный .label
        UIColor(named: "segmentActive") ?? .label
    }
    
    static var segmentInactiveFallback: UIColor {
        // Попытка взять кастомный цвет, если его нет - берем системный .systemGray3
        UIColor(named: "segmentInactive") ?? .systemGray3
    }
}
