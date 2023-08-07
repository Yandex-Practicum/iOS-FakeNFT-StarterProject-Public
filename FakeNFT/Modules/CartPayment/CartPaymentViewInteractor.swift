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
    private var currencies: CurreciesViewModel = []
    private var currenciesCapacity = 0

    private let fetchingQueue = DispatchQueue(label: "com.practicum.yandex.fetch-currency",
                                              attributes: .concurrent)

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
                guard currenciesResult.isEmpty == false else {
                    onSuccess(.empty)
                    break
                }
                self.currenciesCapacity = currenciesResult.count
                self.fetchCurrenciesWithImages(models: currenciesResult, onSuccess: onSuccess, onFailure: onFailure)
            case .failure(let error):
                onFailure(error)
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
                onFailure(error)
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
        models.forEach { [weak self] currency in
            self?.fetchingQueue.async { [weak self] in
                guard let self = self else { return }
                self.prepareCurrencyWithImage(model: currency, onSuccess: onSuccess, onFailure: onFailure)
            }
        }
    }

    func prepareCurrencyWithImage(
        model: Currency,
        onSuccess: @escaping LoadingCompletionBlock<CartPaymentViewModel.ViewState>,
        onFailure: @escaping LoadingFailureCompletionBlock
    ) {
        let imageUrl = URL(string: model.image)
        self.imageLoadingService.fetchImage(url: imageUrl) { [weak self] result in
            switch result {
            case .success(let image):
                let currency = CurrencyViewModelFactory.makeCurrencyViewModel(
                    id: model.id,
                    title: model.title,
                    name: model.name,
                    image: image
                )
                self?.saveCurrency(currency, completion: onSuccess)
            case .failure(let error):
                onFailure(error)
            }
        }
    }

    func saveCurrency(
        _ currency: CurrencyCellViewModel,
        completion: @escaping LoadingCompletionBlock<CartPaymentViewModel.ViewState>
    ) {
        self.currencies.append(currency)
        if self.currencies.count == self.currenciesCapacity {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                completion(.loaded(self.currencies))
                self.currencies.removeAll()
            }
        }
    }
}
