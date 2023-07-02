//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: CatalogDataSourceManagerProtocol) -> Presentable & CatalogMainScreenCoordinatable
}

protocol CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: CartDataSourceManagerProtocol, dataStore: DataStorageProtocol,
                            networkClient: NetworkClient) -> Presentable & CartMainCoordinatableProtocol
    func makeCartDeleteScreenView(dataStore: DataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol
    func makeCartPaymentMethodScreenView(networkClient: NetworkClient,
                                         dataStore: DataStorageProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol
    func makePaymentResultScreenView(networkClient: NetworkClient,
                                     request: NetworkRequest?) -> Presentable & PaymentResultCoordinatable
    func makeCartWebViewScreenView() -> Presentable & WebViewProtocol
}

// MARK: Инъекция зависимостей тут
final class ModulesFactory {}

// MARK: - Ext CatalogModuleFactoryProtocol
extension ModulesFactory: CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: CatalogDataSourceManagerProtocol) -> Presentable & CatalogMainScreenCoordinatable {
        let viewModel = CatalogViewModel()
        return CatalogViewController(dataSource: dataSource, viewModel: viewModel)
    }
}

// MARK: - Ext CartModuleFactoryProtocol
extension ModulesFactory: CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: CartDataSourceManagerProtocol,
                            dataStore: DataStorageProtocol,
                            networkClient: NetworkClient) -> Presentable & CartMainCoordinatableProtocol {
        let viewModel = CartViewModel(dataStore: dataStore, networkClient: networkClient)
        let viewController = CartViewController(dataSource: dataSource, viewModel: viewModel)
        
        return viewController
    }
    
    func makeCartDeleteScreenView(dataStore: DataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol {
        let viewModel = CartDeleteViewModel(dataStore: dataStore)
        let viewController = CartDeleteItemViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCartPaymentMethodScreenView(networkClient: NetworkClient,
                                         dataStore: DataStorageProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol {
        let viewModel = CartPaymentMethodViewModel(networkClient: networkClient, dataStore: dataStore)
        let dataSource = PaymentMethodDataSourceManager()
        let viewController = CartPaymentMethodViewController(viewModel: viewModel, dataSource: dataSource)
        return viewController
    }
    
    func makePaymentResultScreenView(networkClient: NetworkClient,
                                     request: NetworkRequest?) -> Presentable & PaymentResultCoordinatable {
        let viewModel = CartPaymentResultViewModel(networkClient: networkClient)
        viewModel.request = request
        let viewController = CartPaymentResultViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCartWebViewScreenView() -> Presentable & WebViewProtocol {
        let viewController = WebViewController()
        return viewController
    }
}
