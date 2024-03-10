//
//  File.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit

protocol CartPresenterProtocol {
    var cellsModels: [CartCellModel] { get }

    func viewWillAppear()
    func viewDidLoad()
    func deleteNFT()
    func didSelectCellToDelete(id: String)
    func toPaymentButtonTapped()
    func sortButtonTapped()
    func refreshTableViewCalled()
}

final class CartPresenter: CartPresenterProtocol {
    // MARK: - Parameters

    private let cartService: CartServiceProtocol
    private let userDefaults: UserDefaultsProtocol
    private let router: CartRouterProtocol
    
    weak var view: CartViewProtocol?
    
    var cellsModels: [CartCellModel] = []

    private var choosedNFTId: String?

    private var currentState: CartViewState = .empty {
        didSet {
            viewControllerShouldChangeView()
        }
    }

    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ru_RU")
        return numberFormatter
    }()

    private var nfts: [NFT] {
        return cartService.cart
    }

    private var currentCartSortState = CartSortState.name.rawValue

    private var paymentFlowStarted = false

    // MARK: - Initializers
    
    init(
        userDefaults: UserDefaultsProtocol = UserDefaults.standard,
        cartService: CartServiceProtocol,
        router: CartRouterProtocol
    ) {
        self.userDefaults = userDefaults
        self.cartService = cartService
        self.router = router
    }

    // MARK: - Public Methods
    func viewWillAppear() {
        let count = nfts.count
        let totalPrice = calculateTotalPrice()
        view?.updatePayView(count: count, price: totalPrice)
        checkViewState()
        if let savedSortState = userDefaults.string(forKey: Constants.cartSortStateKey) {
            currentCartSortState = savedSortState
        }
        createCellsModels()
        applySorting()
        checkNeedSwitchToCatalogVC()
    }

    func deleteNFT() {
        guard let choosedNFTId else { return }
        cartService.removeFromCart(choosedNFTId) { [weak self] in
            guard let self,
                  let index = cellsModels.firstIndex(where: { $0.id == choosedNFTId })
            else { return }
            checkViewState()
            cellsModels.remove(at: index)
            view?.didDeleteNFT(for: IndexPath(row: index, section: 0))
            view?.updatePayView(count: nfts.count, price: calculateTotalPrice())
            self.choosedNFTId = nil
        }
    }

    func didSelectCellToDelete(id: String) {
        choosedNFTId = id
    }

    func toPaymentButtonTapped() {
        router.showPaymentTypeScreen()
        paymentFlowStarted = true
    }

    func sortButtonTapped() {
        let alerts = [
            AlertModel(
                title: TextLabels.CartViewController.sortByPrice,
                style: .default,
                completion: { [weak self] in self?.sortByPrice() }
            ),
            AlertModel(
                title: TextLabels.CartViewController.sortByRating,
                style: .default,
                completion: { [weak self] in self?.sortByRating() }
            ),
            AlertModel(
                title: TextLabels.CartViewController.sortByName,
                style: .default, completion: { [weak self] in self?.sortByNames() }
            ),
            AlertModel(
                title: TextLabels.CartViewController.closeSorting,
                style: .cancel,
                completion: nil
            )
        ]
        view?.showAlertController(alerts: alerts)
    }

    func refreshTableViewCalled() {
        checkViewState()
        view?.reloadTableView()
    }

    func viewDidLoad() {
        let newCount = cartService.cart.count
        cartCountDidChanged(newCount)
    }

    // MARK: - Private Methods
    private func calculateTotalPrice() -> String {
        let price = nfts.reduce(into: 0) { partialResult, nft in
            partialResult += nft.price
        }
        let number = NSNumber(value: price)
        let formatted = numberFormatter.string(from: number) ?? ""
        return formatted
    }

    private func viewControllerShouldChangeView() {
        switch currentState {
        case .empty:
            view?.displayEmptyCart()
        case .loaded:
            view?.displayLoadedCart()
        }
    }

    private func checkViewState() {
        if nfts.isEmpty {
            currentState = .empty
        } else {
            currentState = .loaded
        }
    }

    private func createCellsModels() {
        cellsModels.removeAll()
        for nft in nfts {
            let priceString = numberFormatter.string(from: NSNumber(value: nft.price)) ?? ""
            let cellModel = CartCellModel(
                id: nft.id, imageURL: nft.images.first, title: nft.name, price: "\(priceString) ETH", rating: nft.rating)
            cellsModels.append(cellModel)
        }
    }

    private func applySorting() {
        switch currentCartSortState {
        case CartSortState.name.rawValue:
            sortByNames()
        case CartSortState.rating.rawValue:
            sortByRating()
        case CartSortState.price.rawValue:
            sortByPrice()
        default:
            return
        }
    }

    private func sortByNames() {
        cellsModels.sort { $0.title < $1.title }
        currentCartSortState = CartSortState.name.rawValue
        didFinishSortCellsModels()
    }

    private func sortByRating() {
        cellsModels.sort { $0.rating > $1.rating }
        currentCartSortState = CartSortState.rating.rawValue
        didFinishSortCellsModels()
    }

    private func sortByPrice() {
        cellsModels.sort { $0.price < $1.price }
        currentCartSortState = CartSortState.price.rawValue
        didFinishSortCellsModels()
    }

    private func didFinishSortCellsModels() {
        view?.reloadTableView()
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            userDefaults.set(currentCartSortState, forKey: Constants.cartSortStateKey)
        }
    }

    private func checkNeedSwitchToCatalogVC() {
        if paymentFlowStarted && cartService.cart.isEmpty {
            paymentFlowStarted = false
            view?.switchToCatalogVC()
        }
    }
}

// MARK: - CartServiceDelegate

extension CartPresenter: CartServiceDelegate {
    func cartCountDidChanged(_ newCount: Int) {
        let badgeValue = newCount > 0 ? String(newCount) : nil
        view?.updateTabBarItem(newValue: badgeValue)
    }
}

// MARK: - CartViewState

extension CartPresenter {
    enum CartViewState {
        case empty
        case loaded
    }
}

// MARK: - CartSortState

extension CartPresenter {
    enum CartSortState: String {
        case name
        case rating
        case price
    }
}

// MARK: - Constants

extension CartPresenter {
    enum Constants {
        static let cartSortStateKey = "cartSortStateKey"
    }
}
