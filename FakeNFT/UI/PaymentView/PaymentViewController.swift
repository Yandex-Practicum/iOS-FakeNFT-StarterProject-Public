//
//  PaymentView.swift
//  FakeNFT
//
//  Created by Сергей Петров on 20.07.2026.
//

import UIKit
import Observation
import WebKit // Добавляем для WebView

// MARK: - PaymentViewController
final class PaymentViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: PaymentViewModel
    
    // MARK: - UI Elements (Collection)
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - UI Elements (Pay Block)
    private let payBlockView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "yaLightGrey") ?? .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Совершая покупку, вы соглашаетесь с условиями", comment: "")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "yaBlack") ?? .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let agreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Пользовательского соглашения", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(UIColor(named: "uniBlue") ?? .systemBlue, for: .normal)
        button.contentHorizontalAlignment = .leading // Аналог alignment: .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Оплатить", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(named: "yaWhite") ?? .white, for: .normal)
        button.backgroundColor = UIColor(named: "yaBlack") ?? .black
        button.layer.cornerRadius = CartSizeConstants.payButtonRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Diffable DataSource
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Currency>
    private enum Section: Hashable { case main }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Currency> = {
        UICollectionViewDiffableDataSource<Section, Currency>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, currency in
            guard let self else { return UICollectionViewCell() }
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PaymentCurrencyCollectionViewCell.reuseID,
                for: indexPath
            ) as! PaymentCurrencyCollectionViewCell
            
            let isSelected = viewModel.selectedCurrencyId == currency.id
            
            cell.configure(with: currency, isSelected: isSelected) { [weak self] tappedCurrency in
                self?.viewModel.selectCurrency(tappedCurrency)
            }
            
            return cell
        }
    }()
    
    // MARK: - Init
    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupCollectionView()
        setupPayBlock() // ⭐ Новый метод
        observeViewModel()
        applyInitialSnapshot()
        updatePayButtonState() // ⭐ Первичное состояние кнопки
    }
    
    // MARK: - Setup
    private func setupNavigation() {
        title = NSLocalizedString("Выберите способ оплаты", comment: "Заголовок выбора оплаты")
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        view.addSubview(payBlockView) // Добавляем нижний блок
        
        NSLayoutConstraint.activate([
            // Collection View занимает всё пространство сверху до payBlockView
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: payBlockView.topAnchor),
            
            // Pay Block прижат к самому низу экрана (игнорирует safe area, как в SwiftUI)
            payBlockView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            payBlockView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            payBlockView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(
            PaymentCurrencyCollectionViewCell.self,
            forCellWithReuseIdentifier: PaymentCurrencyCollectionViewCell.reuseID
        )
    }
    
    private func setupPayBlock() {
        // Скругляем только верхние углы
        payBlockView.layer.cornerRadius = CartSizeConstants.payBlockRadius
        payBlockView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        payBlockView.clipsToBounds = true
        
        payBlockView.addSubview(contentStackView)
        payBlockView.addSubview(payButton)
        
        contentStackView.addArrangedSubview(agreementLabel)
        contentStackView.addArrangedSubview(agreementButton)
        
        // Фиксируем высоту кнопки
        payButton.heightAnchor.constraint(equalToConstant: CartSizeConstants.payButtonHeight).isActive = true
        
        // Действия кнопок
        agreementButton.addTarget(self, action: #selector(agreementTapped), for: .touchUpInside)
        payButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
        
        // ⭐ Убираем отступ между текстом и ссылкой (было spacing: 4 в SwiftUI)
        contentStackView.setCustomSpacing(4, after: agreementLabel)
        
        // Констрейнты для текста и ссылки
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: payBlockView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: payBlockView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: payBlockView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16)
        ])
        
        // Констрейнты для кнопки: на всю ширину с отступами 16
        NSLayoutConstraint.activate([
            payButton.leadingAnchor.constraint(equalTo: payBlockView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: payBlockView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: CartSizeConstants.payButtonHeight)
        ])
    }
    
    // MARK: - Compositional Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5), // 50% ширины группы = 2 колонки
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Observation
    private func observeViewModel() {
        withObservationTracking {
            _ = viewModel.selectedCurrencyId
        } onChange: { [weak self] in
            guard let self else { return }
            Task { @MainActor in
                self.collectionView.reloadData()
                self.updatePayButtonState() // ⭐ Обновляем состояние кнопки при смене валюты
                self.observeViewModel()
            }
        }
    }
    
    // MARK: - Snapshot
    private func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.currencies, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - State Updates
    private func updatePayButtonState() {
        let isDisabled = viewModel.selectedCurrencyId.isEmpty
        payButton.isEnabled = !isDisabled
        payButton.alpha = isDisabled ? 0.6 : 1.0 // Аналог .opacity(isDisabled ? 0.6 : 1)
    }
    
    // MARK: - Actions
    @objc private func agreementTapped() {
        guard let url = URL(string: CartRequestsConstants.webViewURL) else { return }
        let webVC = WebViewController(url: url)
        // Скрываем таб-бар и для веб-вью тоже
        webVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    // В PaymentViewController при успешной оплате:
    @objc private func payTapped() {
        let successVC = SuccessPaymentViewController { [weak self] in
            // Логика возврата: например, очистить корзину или вернуться на главный экран
            print("Возврат в корзину")
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        // Показываем модально (как sheet в SwiftUI) или пушим
        // navigationController?.pushViewController(successVC, animated: true)
        successVC.modalPresentationStyle = .fullScreen
        present(successVC, animated: true)
    }
}

// MARK: - Collection View Cell Wrapper
final class PaymentCurrencyCollectionViewCell: UICollectionViewCell {
    static let reuseID = "PaymentCurrencyCollectionViewCell"
    
    private let currencyView = CurrencyCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = superview?.superview as? UICollectionView else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        let width = collectionView.bounds.width / 2 - 4 // Половина ширины минус половина spacing
        var attributes = layoutAttributes
        attributes.frame.size.width = width
        return attributes
    }
    
    private func setupUI() {
        selectedBackgroundView = UIView()
        contentView.addSubview(currencyView)
        currencyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currencyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currencyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currencyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            currencyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with currency: Currency, isSelected: Bool, onTap: @escaping (Currency) -> Void) {
        currencyView.configure(with: currency, isSelected: isSelected, onTap: onTap)
    }
}
