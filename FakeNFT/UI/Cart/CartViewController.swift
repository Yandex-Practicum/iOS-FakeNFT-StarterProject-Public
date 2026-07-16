//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//
import UIKit
import Observation

final class CartViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: CartViewModel
    
    // Действие при нажатии на кнопку оплаты (можно передать извне или обрабатывать здесь)
    var onPaymentTapped: (() -> Void)?
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Total Section UI
    private let totalSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .segmentInactiveFallback // Фон из SwiftUI
        view.layer.cornerRadius = SizeConstants.totalSectionRadius
        view.clipsToBounds = true // Чтобы cornerRadius работал для фона
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 16 // Расстояние между текстом и кнопкой
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2 // spacing: 2 из SwiftUI VStack
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular) // .regular15
        label.textColor = .segmentActiveFallback
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold) // .bold17
        label.textColor = .systemGreen // .green из SwiftUI
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("To payment", comment: "Кнопка оплаты"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold) // .bold17
        button.backgroundColor = .black // TODO: ЗАМЕНИТЬ ЦВЕТ на нужный
        button.layer.cornerRadius = SizeConstants.buttonRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Diffable DataSource
    private enum Section: Hashable { case main }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, CartItem> = {
        UITableViewDiffableDataSource<Section, CartItem>(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseID, for: indexPath) as! CartCell
            
            cell.configure(with: item) { [weak self] deletedItem in
                self?.viewModel.removeItem(deletedItem)
            }
            return cell
        }
    }()
    
    // MARK: - Init
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupTotalSection()
        observeViewModel()
        applyInitialSnapshot()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("Cart", comment: "Заголовок экрана корзины")
        
        view.addSubview(tableView)
        view.addSubview(totalSectionView)
        
        NSLayoutConstraint.activate([
            // Таблица занимает всё пространство сверху до totalSection
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalSectionView.topAnchor, constant: -16), // Отступ 16 от нижней панели
            
            // Нижняя панель прижата к низу с горизонтальными отступами 16 (аналог .padding(.horizontal, 16))
            totalSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalSectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            totalSectionView.heightAnchor.constraint(equalToConstant: SizeConstants.totalSectionHeight)
        ])
    }
    
    private func setupTableView() {
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
        tableView.delegate = self
    }
    
    private func setupTotalSection() {
        totalSectionView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(infoStackView)
        contentStackView.addArrangedSubview(paymentButton)
        
        infoStackView.addArrangedSubview(countLabel)
        infoStackView.addArrangedSubview(totalPriceLabel)
        
        // Фиксируем размеры кнопки (аналог .frame(width:height:))
        NSLayoutConstraint.activate([
            paymentButton.widthAnchor.constraint(equalToConstant: SizeConstants.buttonWidth),
            paymentButton.heightAnchor.constraint(equalToConstant: SizeConstants.buttonHeight),
            
            // Внутренние отступы для contentStackView (аналог .padding(.horizontal, 16) внутри HStack)
            contentStackView.topAnchor.constraint(equalTo: totalSectionView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: totalSectionView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: totalSectionView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: totalSectionView.bottomAnchor, constant: -12)
        ])
        
        // Обработчик нажатия на кнопку
        paymentButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Observation (iOS 17+ @Observable)
    private func observeViewModel() {
        withObservationTracking {
            _ = viewModel.items
        } onChange: { [weak self] in
            guard let self else { return }
            Task { @MainActor in
                self.applySnapshot(animating: true)
                self.updateTotalSection() // <-- Обновляем нижнюю панель при изменении данных!
                self.observeViewModel()   // Перезапускаем наблюдение
            }
        }
    }
    
    // MARK: - Data & UI Updates
    private func applyInitialSnapshot() {
        applySnapshot(animating: false)
        updateTotalSection() // Первичная отрисовка нижней панели
    }
    
    private func applySnapshot(animating: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CartItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }
    
    private func updateTotalSection() {
        // Обновляем тексты на основе актуальных данных ViewModel
        countLabel.text = "\(viewModel.items.count) NFT"
        totalPriceLabel.text = String(format: "%.2f ETH", viewModel.totalPrice)
        
        // Опционально: скрыть или показать панель, если корзина пуста
        totalSectionView.isHidden = viewModel.items.isEmpty
    }
    
    // MARK: - Actions
    @objc private func paymentButtonTapped() {
        // Здесь логика перехода к оплате
        onPaymentTapped?()
        print("Переход к оплате на сумму: \(viewModel.totalPrice) ETH")
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Size Constants (можно вынести в отдельный файл)
private enum SizeConstants {
    static let totalSectionHeight: CGFloat = 72
    static let totalSectionRadius: CGFloat = 16
    static let buttonWidth: CGFloat = 140
    static let buttonHeight: CGFloat = 44
    static let buttonRadius: CGFloat = 12
}
