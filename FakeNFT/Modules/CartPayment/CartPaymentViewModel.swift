//
//  CartPaymentViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 06.08.2023.
//

import Foundation

protocol CartPaymentViewModelProtocol {
    var currencies: Box<CurreciesViewModel> { get }
    var cartPaymentViewState: Box<CartPaymentViewModel.ViewState> { get }
    var isPurchaseSuccessful: Box<CartPaymentViewModel.PurchaseState> { get }
    var error: Box<Error?> { get }

    func fetchCurrencies()
    func purсhase(currencyId: String)
}

final class CartPaymentViewModel {
    enum ViewState {
        case loading
        case loaded(CurreciesViewModel?)
        case empty
    }

    enum PurchaseState {
        case success
        case failure
        case didNotHappen
    }

    private(set) var currencies = Box<CurreciesViewModel>([])
    private(set) var cartPaymentViewState = Box<ViewState>(.loading)
    private(set) var isPurchaseSuccessful = Box<PurchaseState>(.didNotHappen)
    private(set) var error = Box<Error>(nil)

    private let orderId: String

    private lazy var successFetchCompletion: LoadingCompletionBlock<ViewState> = { [weak self] (viewState: ViewState) in
        guard let self = self else { return }

        switch viewState {
        case .loaded(let currencies):
            guard let currencies = currencies else { return }
            self.cartPaymentViewState.value = viewState
            self.currencies.value = currencies
        default:
            break
        }
    }

    private lazy var purchaseCompletion: LoadingCompletionBlock<PurchaseState> = { [weak self] purchaseState in
        guard let self = self else { return }
        self.cartPaymentViewState.value = .loaded(nil)
        self.isPurchaseSuccessful.value = purchaseState
    }

    private lazy var failureCompletion: LoadingFailureCompletionBlock = { [weak self] error in
        self?.error.value = error
        self?.cartViewState.value = .empty
    }

    private let cartPaymentInteractor: CartPaymentViewInteractorProtocol

    init(orderId: String, interactor: CartPaymentViewInteractorProtocol) {
        self.orderId = orderId
        self.cartPaymentInteractor = interactor
    }
}

// MARK: - CartPaymentViewModelProtocol
extension CartPaymentViewModel: CartPaymentViewModelProtocol {
    func fetchCurrencies() {
        switch self.cartPaymentViewState.value {
        case .loading:
            break
        default:
            self.cartPaymentViewState.value = .loading
        }

        self.cartPaymentInteractor.fetchCurrencies(
            onSuccess: self.successFetchCompletion,
            onFailure: self.failureCompletion
        )
    }

    func purсhase(currencyId: String) {
        self.cartPaymentViewState.value = .loading
        self.cartPaymentInteractor.purchase(
            orderId: self.orderId,
            currencyId: currencyId,
            onSuccess: self.purchaseCompletion,
            onFailure: self.failureCompletion
        )
    }
}
