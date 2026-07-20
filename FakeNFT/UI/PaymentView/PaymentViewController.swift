//
//  PaymentView.swift
//  FakeNFT
//
//  Created by Сергей Петров on 20.07.2026.
//

import UIKit
import Observation

// MARK: - PaymentViewController
final class PaymentViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: PaymentViewModel
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
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
        
        // Скрывает таб-бар при переходе на этот экран
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
        observeViewModel()
        applyInitialSnapshot()
    }
    
    // MARK: - Setup
    private func setupNavigation() {
        // Задаем заголовок. Стандартная кнопка "Назад" появится автоматически
        // благодаря тому, что экран открыт через UINavigationController
        title = NSLocalizedString("Выберите способ оплаты", comment: "Заголовок выбора оплаты")
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(
            PaymentCurrencyCollectionViewCell.self,
            forCellWithReuseIdentifier: PaymentCurrencyCollectionViewCell.reuseID
        )
    }
    
    // MARK: - Compositional Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        // 1. Элемент (ячейка)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5), // ⭐ ИСПРАВЛЕНО: 0.5 = 50% ширины группы
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 2. Группа (строка)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), // 100% ширины экрана
            heightDimension: .estimated(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item] // Два элемента
        )
        group.interItemSpacing = .fixed(8)

        // 3. Секция
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Observation (iOS 17+ @Observable)
    private func observeViewModel() {
        withObservationTracking {
            // 1. Читаем свойство, чтобы начать отслеживание
            _ = viewModel.selectedCurrencyId
        } onChange: { [weak self] in
            // 2. Этот блок сработает при изменении ID
            guard let self else { return }
            
            // 3. Обновляем UI строго на главном потоке
            Task { @MainActor in
                // Используем reloadData вместо reloadItems.
                // Для маленького списка валют это мгновенно и на 100% безопасно
                // (избегает конфликтов с анимацией нажатия на ячейку).
                self.collectionView.reloadData()
                
                // 4. Перезапускаем отслеживание для следующего изменения,
                // так как withObservationTracking срабатывает только один раз
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
        //  ВАЖНО: Принудительно указываем, что ячейка должна быть 50% ширины collectionView
        // Это заставляет Collection View размещать 2 ячейки в ряд
        guard let collectionView = superview?.superview as? UICollectionView else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        let width = collectionView.bounds.width / 2 - 8 // Делим на 2 колонки и вычитаем половину spacing
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
