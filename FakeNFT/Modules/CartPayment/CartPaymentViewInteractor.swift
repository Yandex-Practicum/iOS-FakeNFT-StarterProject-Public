//
//  CartPaymentViewInteractor.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 06.08.2023.
//

import Foundation

protocol CartPaymentViewInteractorProtocol {
    func fetchCurrencies(onSuccess: @escaping LoadingCompletionBlock<CartPaymentViewModel.ViewState>,
                         onFailure: @escaping LoadingFailureCompletionBlock)
    func purchase(orderId: String,
                  currencyId: String,
                  onSuccess: @escaping LoadingCompletionBlock<CartPaymentViewModel.PurchaseState>,
                  onFailure: @escaping LoadingFailureCompletionBlock)
}

final class CartPaymentViewInteractor {
    private var currencies: CurrenciesViewModel = []

    private let fetchingQueue = DispatchQueue.global(qos: .userInitiated)
    private let fetchingGroup = DispatchGroup()

    private let currenciesService: CurrenciesServiceProtocol
    private let imageLoadingService: ImageLoadingServiceProtocol
    private let orderPaymentService: OrderPaymentServiceProtocol

    init(
        currenciesService: CurrenciesServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol,
        orderPaymentService: OrderPaymentServiceProtocol
    ) {
        self.currenciesService = currenciesService
        self.imageLoadingService = imageLoadingService
        self.orderPaymentService = orderPaymentService
    }
}

// MARK: - CartPaymentViewInteractorProtocol
extension CartPaymentViewInteractor: CartPaymentViewInteractorProtocol {
    func fetchCurrencies(
        onSuccess: @escaping LoadingCompletionBlock<CartPaymentViewModel.ViewState>,
        onFailure: @escaping LoadingFailureCompletionBlock
    ) {
        self.currenciesService.fetchCurrencies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currenciesResult):
                guard !currenciesResult.isEmpty else {
                    onSuccess(.empty)
                    return
                }
                self.fetchCurrenciesWithImages(models: currenciesResult, onSuccess: onSuccess, onFailure: onFailure)
            case .failure(let error):
                self.handleError(error: error, onFailure: onFailure)
            }
        }
    }

    func purchase(
        orderId: String,
        currencyId: String,
        onSuccess: @escaping LoadingCompletionBlock<CartPaymentViewModel.PurchaseState>,
        onFailure: @escaping LoadingFailureCompletionBlock
    ) {
        self.orderPaymentService.purchase(orderId: orderId, currencyId: currencyId) { result in
            switch result {
            case .success(let purchase):
                let state: CartPaymentViewModel.PurchaseState = purchase.success ? .success : .failure
                onSuccess(state)
            case .failure(let error):
                self.handleError(error: error, onFailure: onFailure)
            }
        }
    }
}

private extension CartPaymentViewInteractor {
    func fetchCurrenciesWithImages(
        models: CurrenciesResult,
        onSuccess: @escaping LoadingCompletionBlock<CartPaymentViewModel.ViewState>,
        onFailure: @escaping LoadingFailureCompletionBlock
    ) {
        let currencyLoadingCompletion = { [weak self] currency in
            self?.currencies.append(currency)
            self?.fetchingGroup.leave()
        }

        models.forEach { [weak self] currencyModel in
            self?.fetchingGroup.enter()

            self?.fetchingQueue.async { [weak self] in
                self?.prepareCurrencyWithImage(
                    model: currencyModel,
                    onFailure: onFailure,
                    completion: currencyLoadingCompletion
                )
            }
        }

        self.fetchingGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            onSuccess(.loaded(self.currencies))
            self.currencies.removeAll()
        }
    }

    func prepareCurrencyWithImage(
        model: Currency,
        onFailure: @escaping LoadingFailureCompletionBlock,
        completion: @escaping LoadingCompletionBlock<CurrencyCellViewModel>
    ) {
        let imageUrl = URL(string: model.image)
        self.imageLoadingService.fetchImage(url: imageUrl) { [weak self] result in
            switch result {
            case .success(let image):
                let currency = CurrencyViewModelFactory.makeCurrencyCellViewModel(
                    id: model.id,
                    title: model.title,
                    name: model.name,
                    image: image
                )
                completion(currency)
            case .failure(let error):
                self?.handleError(error: error, onFailure: onFailure)
            }
        }
    }
}

private extension CartPaymentViewInteractor {
    func handleError(error: Error, onFailure: @escaping LoadingFailureCompletionBlock) {
        DispatchQueue.main.async {
            onFailure(error)
        }
    }
}
