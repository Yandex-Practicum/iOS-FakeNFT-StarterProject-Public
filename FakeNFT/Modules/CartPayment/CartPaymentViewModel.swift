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

    func fetchCurrencies()
    func purсhase(currencyId: String)
}

final class CartPaymentViewModel {
    enum ViewState {
        case loading
        case loaded(CurreciesViewModel)
        case empty
    }

    private(set) var currencies = Box<CurreciesViewModel>([])
    private(set) var cartPaymentViewState = Box<ViewState>(.loading)

    private let orderId: String

    private lazy var successCompletion: LoadingCompletionBlock<ViewState> = { [weak self] (viewState: ViewState) in
        guard let self = self else { return }

        switch viewState {
        case .loaded(let currencies):
            self.cartPaymentViewState.value = viewState
            self.currencies.value = currencies
        default:
            break
        }
    }

    private lazy var failureCompletion: LoadingFailureCompletionBlock = { [weak self] error in
        print(error)
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
        self.cartPaymentInteractor.fetchCurrencies(onSuccess: self.successCompletion, onFailure: self.failureCompletion)
    }

    func purсhase(currencyId: String) {

    }
}
