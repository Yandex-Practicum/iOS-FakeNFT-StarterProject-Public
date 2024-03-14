//
//  Payment.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit
import SafariServices

protocol PaymentPresenterProtocol {
    var currenciesCellModel: [CurrencyCellModel] { get }
    var viewController: PaymentViewControllerProtocol? { get set }

    func viewDidLoad()
    func didSelectItemAt(_ indexPath: IndexPath)
    func userAgreementButtonTapped()
    func payButtonTapped()
}

final class PaymentPresenter: PaymentPresenterProtocol {
    // MARK: - Public Properties
    weak var viewController: PaymentViewControllerProtocol?
    var currenciesCellModel: [CurrencyCellModel] = []

    // MARK: - Private Properties
    private let networkManager: NetworkManagerProtocol
    private var paymentManager: PaymentManagerProtocol
    private let paymentRouter: PaymentRouterProtocol
    private let cartService: CartServiceProtocol
    private var currentState: PaymentViewState? {
        didSet {
            viewControllerShouldChangeView()
        }
    }
    private var currencies: [Currency] = []
    private var seletedItemIndexPath: IndexPath?
    private var currencyId: Int? {
        guard let seletedItemIndexPath else { return nil }
        return Int(currencies[seletedItemIndexPath.row].id)
    }
    private var payButtonState: PayButtonState? {
        didSet {
            viewControllerShouldChnangeButtonAppearance()
        }
    }
    private var paymentIsSucceeded: Bool?

    // MARK: - Initializers
    init(networkManager: NetworkManagerProtocol,
         paymentManager: PaymentManagerProtocol,
         cartService: CartServiceProtocol,
         paymentRouter: PaymentRouterProtocol
    ) {
        self.networkManager = networkManager
        self.paymentManager = paymentManager
        self.cartService = cartService
        self.paymentRouter = paymentRouter
//        self.paymentManager.delegate = self
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        checkState()
        payButtonState = .disabled
        fetchCurrencies()
    }

    func didSelectItemAt(_ indexPath: IndexPath) {
        seletedItemIndexPath = indexPath
        makeCurrenciesCellModel()
        viewController?.reloadCollectionView()
        payButtonState = .enabled
    }

    func userAgreementButtonTapped() {
        guard let url = URL(string: Constants.termsOfUseURL) else { return }
        let safariViewController = SFSafariViewController(url: url)
        viewController?.presentView(safariViewController)
    }

    func payButtonTapped() {
        guard let currencyId else { return }
        let nfts = getNFTSIds()
        payButtonState = .loading
        paymentManager.performPayment(nfts: nfts, currencyId: currencyId)
    }

    // MARK: - Private Methods
    private func fetchCurrencies() {
        let request = CurrenciesRequest()
        networkManager.send(request: request, type: [Currency].self, id: request.requestId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let currencies):
                DispatchQueue.main.async {
                    self.currencies = currencies
                    self.makeCurrenciesCellModel()
                    self.checkState()
                    self.viewController?.reloadCollectionView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func checkState() {
        currentState = currencies.isEmpty ? .loading : .loaded
    }

    private func viewControllerShouldChangeView() {
        guard let currentState else { return }

        switch currentState {
        case .loading:
            viewController?.displayLoadingIndicator()
        case .loaded:
            viewController?.removeLoadingIndicator()
        }
    }

    private func makeCurrenciesCellModel() {
        currenciesCellModel.removeAll()
        for (index, currency) in currencies.enumerated() {
            let isSelected = index == seletedItemIndexPath?.row
            let model = CurrencyCellModel(
                imageURL: currency.image,
                title: currency.title,
                ticker: currency.ticker,
                isSelected: isSelected)
            currenciesCellModel.append(model)
        }
    }

    private func getNFTSIds() -> [String] {
        var ids: [String] = []
        for nft in cartService.cart {
            ids.append(nft.id)
        }
        return ids
    }

    private func viewControllerShouldChnangeButtonAppearance() {
        guard let payButtonState else { return }
        switch payButtonState {
        case .disabled:
            viewController?.changeButtonState(color: .yaWhiteDayNight, isEnabled: false, isLoading: false)
        case .enabled:
            viewController?.changeButtonState(color: .yaBlackDayNight, isEnabled: true, isLoading: false)
        case .loading:
            viewController?.changeButtonState(color: .yaBlackDayNight, isEnabled: false, isLoading: true)
        }
    }
}

// MARK: - PaymentViewState
extension PaymentPresenter {
    enum PaymentViewState {
        case loading
        case loaded
    }
}

// MARK: - Constants
extension PaymentPresenter {
    private enum Constants {
        static let termsOfUseURL = "https://yandex.ru/legal/practicum_termsofuse/"
    }
}

// MARK: - PaymentManagerDelegate
//extension PaymentPresenter: PaymentManagerDelegate {
//    func paymentFinishedWithError(_ error: Error) {
//        DispatchQueue.main.async { [weak self] in
//            let presenter = PaymentConfirmationPresenter(configuration: .failure)
//            presenter.delegate = self
//            let confirmationViewController = PaymentConfirmationViewController(presenter: presenter)
//            confirmationViewController.modalPresentationStyle = .fullScreen
//            self?.viewController?.presentView(confirmationViewController)
//            self?.payButtonState = .enabled
//           self?.paymentIsSucceeded = false
//        }
//    }

//    func paymentFinishedWithSuccess() {
//        DispatchQueue.main.async { [weak self] in
//            let presenter = PaymentConfirmationPresenter(configuration: .success)
//            presenter.delegate = self
//           let confirmationViewController = PaymentConfirmationViewController(presenter: presenter)
//            confirmationViewController.modalPresentationStyle = .fullScreen
//            self?.viewController?.presentView(confirmationViewController)
//            self?.payButtonState = .enabled
//            self?.paymentIsSucceeded = true
//        }
//    }
//}

// MARK: - PayButtonState
extension PaymentPresenter {
    enum PayButtonState {
        case disabled
        case enabled
        case loading
    }
}

//extension PaymentPresenter: PaymentConfirmationPresenterDelegate {
//   func didTapDismissButton() {
//        viewController?.dismiss()
//        guard let paymentIsSucceeded,
//        paymentIsSucceeded else { return }
//        cartController.removeAll { [weak self] in
//            self?.viewController?.popToRootViewController(animated: true)
//        }
//    }
//}
