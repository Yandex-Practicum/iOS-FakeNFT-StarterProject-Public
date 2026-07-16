//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//

import UIKit
import Observation

// MARK: - CartViewController
final class CartViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: CartViewModel
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // Плейсхолдер для будущей нижней панели с ценой (аналог EmptyView в SwiftUI)
    private let priceSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Diffable DataSource
    private enum Section: Hashable { case main }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, CartItem> = {
        UITableViewDiffableDataSource<Section, CartItem>(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseID, for: indexPath) as! CartCell
            
            // Передаём замыкание удаления из ячейки в ViewModel
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
        setupDataSource()
        observeViewModel()
        applyInitialSnapshot()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("Cart", comment: "Заголовок экрана корзины")
        
        view.addSubview(tableView)
        view.addSubview(priceSectionView)
        
        NSLayoutConstraint.activate([
            // Список занимает всё пространство сверху до priceSection
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: priceSectionView.topAnchor),
            
            // Нижняя панель (пока пустая, высота 0)
            priceSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceSectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            priceSectionView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    private func setupTableView() {
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
        tableView.delegate = self
    }
    
    private func setupDataSource() {
        // DataSource уже настроен через lazy var
    }
    
    // MARK: - Observation (iOS 17+ @Observable)
    private func observeViewModel() {
        withObservationTracking {
            // Следим за свойством items
            _ = viewModel.items
        } onChange: { [weak self] in
            guard let self else { return }
            
            // Колбэк вызывается на фоновом потоке, переключаемся на главный
            Task { @MainActor in
                self.applySnapshot(animating: true)
                // ВАЖНО: перезапускаем наблюдение, т.к. withObservationTracking срабатывает только один раз
                self.observeViewModel()
            }
        }
    }
    
    /*
     // MARK: - Alternative: Combine (для iOS 15/16)
     // Раскомментируй этот блок и удали observeViewModel() выше, если Deployment Target < 17
     
     private var cancellables = Set<AnyCancellable>()
     
     private func observeViewModel() {
         viewModel.$items
             .receive(on: RunLoop.main)
             .sink { [weak self] _ in
                 self?.applySnapshot(animating: true)
             }
             .store(in: &cancellables)
     }
     */
    
    // MARK: - Snapshot
    private func applyInitialSnapshot() {
        applySnapshot(animating: false)
    }
    
    private func applySnapshot(animating: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CartItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        // Здесь можно открыть детали товара, например:
        // let detailsVC = NFTDetailsViewController(item: item)
        // navigationController?.pushViewController(detailsVC, animated: true)
        print("Selected: \(item.name)")
    }
    
    // Убираем стандартные insets у строк
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = .zero
    }
}

// MARK: - Preview Helper (для запуска из AppDelegate / SceneDelegate)
/*
 В SceneDelegate.swift:
 
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     guard let windowScene = (scene as? UIWindowScene) else { return }
     
     let window = UIWindow(windowScene: windowScene)
     let viewModel = CartViewModel()
     let cartVC = CartViewController(viewModel: viewModel)
     let navController = UINavigationController(rootViewController: cartVC)
     
     window.rootViewController = navController
     window.makeKeyAndVisible()
     self.window = window
 }
 */
