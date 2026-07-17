//
//  CartItemCell.swift
//  FakeNFT
//
//  Created by Сергей Петров on 17.07.2026.
//
import UIKit

final class CartItemCell: UITableViewCell {
    static let reuseId = "CartItemCell"

    // MARK: - Callbacks
    var onDelete: (() -> Void)?

    // MARK: - UI Elements
    private let thumbImageView = UIImageView()
    private let titleLabel = UILabel()
    private let starsStackView = UIStackView()
    private let priceTitleLabel = UILabel()
    private let priceValueLabel = UILabel()
    private let deleteButton = UIButton(type: .custom)

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        // 1. Картинка (Image)
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.layer.cornerRadius = CartSizeConstants.cellImageCornerRadius
        thumbImageView.clipsToBounds = true
        thumbImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbImageView.widthAnchor.constraint(equalToConstant: CartSizeConstants.cellImageSize).isActive = true
        thumbImageView.heightAnchor.constraint(equalToConstant: CartSizeConstants.cellImageSize).isActive = true

        // 2. Название (Text item.name)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold) // .bold17
        titleLabel.textColor = UIColor(named: "yaBlack") ?? .black
        titleLabel.numberOfLines = 1

        // 3. Звездочки (HStack with 5 stars)
        starsStackView.axis = .horizontal
        starsStackView.spacing = 2
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        let defaultStarColor = UIColor(named: "yaLightGrey") ?? .lightGray
        
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: "Stars")?.withRenderingMode(.alwaysTemplate)
            starImageView.tintColor = defaultStarColor
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            // Задаем фиксированный размер звездочке (примерно 12-14pt)
            starImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
            starsStackView.addArrangedSubview(starImageView)
        }

        // 4. Цена: заголовок (Text "Price")
        priceTitleLabel.text = NSLocalizedString("Цена", comment: "")
        priceTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular) // .regular13
        priceTitleLabel.textColor = UIColor(named: "yaBlack") ?? .black

        // 5. Цена: значение (Text "... ETH")
        priceValueLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold) // .bold17
        priceValueLabel.textColor = UIColor(named: "yaBlack") ?? .black

        // 6. Вертикальный стек информации (VStack)
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, starsStackView, priceTitleLabel, priceValueLabel])
        infoStack.axis = .vertical
        infoStack.alignment = .leading
        // Точное воспроизведение padding(.bottom, X) из SwiftUI через кастомные отступы
        infoStack.setCustomSpacing(6, after: titleLabel)
        infoStack.setCustomSpacing(14, after: starsStackView)
        infoStack.setCustomSpacing(4, after: priceTitleLabel)

        // 7. Кнопка удаления (Button with cartOn image)
        let cartImage = UIImage(named: "cartOn")?.withRenderingMode(.alwaysTemplate)
        deleteButton.setImage(cartImage, for: .normal)
        deleteButton.tintColor = UIColor(named: "yaBlack") ?? .black
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        // Увеличиваем область нажатия (hitbox), как contentShape(Rectangle()) + padding в SwiftUI
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        // 8. Распорка (Spacer)
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // 9. Главный горизонтальный стек (HStack)
        let mainStack = UIStackView(arrangedSubviews: [thumbImageView, infoStack, spacer, deleteButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 20 // spacing: 20 из SwiftUI
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        // 10. Констрейнты главного стека (padding 16 со всех сторон)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration
    func configure(with item: CartItem) {
        // Картинка (используйте item.imageName, если имя картинки отличается от имени)
        thumbImageView.image = UIImage(named: item.name)
        
        // Тексты
        titleLabel.text = item.name
        priceValueLabel.text = String(format: "%.2f ETH", item.price)
        
        // Обновление цвета звездочек
        let activeStarColor: UIColor = .systemYellow
        let inactiveStarColor: UIColor = UIColor(named: "yaLightGrey") ?? .lightGray
        
        for (index, view) in starsStackView.arrangedSubviews.enumerated() {
            if let starImageView = view as? UIImageView {
                starImageView.tintColor = index < item.rating ? activeStarColor : inactiveStarColor
            }
        }
    }

    // MARK: - Actions
    @objc private func deleteTapped() {
        onDelete?()
    }
}
