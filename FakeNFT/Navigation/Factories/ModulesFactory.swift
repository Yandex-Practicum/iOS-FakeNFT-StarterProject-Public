//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: CatalogDataSourceManagerProtocol,
                               dataStore: CatalogDataStorageProtocol,
                               networkClient: NetworkClient) -> Presentable & CatalogMainScreenCoordinatable
    func makeCatalogCollectionScreenView(with collection: NftCollection) -> Presentable & CatalogCollectionCoordinatable
}

protocol CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: CartDataSourceManagerProtocol, dataStore: CartDataStorageProtocol,
                            networkClient: NetworkClient) -> Presentable & CartMainCoordinatableProtocol
    func makeCartDeleteScreenView(dataStore: CartDataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol
    func makeCartPaymentMethodScreenView(networkClient: NetworkClient,
                                         dataStore: CartDataStorageProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol
    func makePaymentResultScreenView(networkClient: NetworkClient,
                                     request: NetworkRequest?) -> Presentable & PaymentResultCoordinatable
    func makeCartWebViewScreenView() -> Presentable & WebViewProtocol
}

final class ModulesFactory {}

// MARK: - Ext CatalogModuleFactoryProtocol
extension ModulesFactory: CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: CatalogDataSourceManagerProtocol,
                               dataStore: CatalogDataStorageProtocol,
                               networkClient: NetworkClient) -> Presentable & CatalogMainScreenCoordinatable {
        let viewModel = CatalogViewModel(dataStore: dataStore, networkClient: networkClient)
        return CatalogViewController(dataSource: dataSource, viewModel: viewModel)
    }
    
    func makeCatalogCollectionScreenView(with collection: NftCollection) -> Presentable & CatalogCollectionCoordinatable {
        let viewModel = CatalogCollectionViewModel(nftCollection: collection)
        let viewController = CatalogCollectionViewController(viewModel: viewModel)
        return viewController
    }
}

// MARK: - Ext CartModuleFactoryProtocol
extension ModulesFactory: CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: CartDataSourceManagerProtocol,
                            dataStore: CartDataStorageProtocol,
                            networkClient: NetworkClient) -> Presentable & CartMainCoordinatableProtocol {
        let viewModel = CartViewModel(dataStore: dataStore, networkClient: networkClient)
        let viewController = CartViewController(dataSource: dataSource, viewModel: viewModel)
        
        return viewController
    }
    
    func makeCartDeleteScreenView(dataStore: CartDataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol {
        let viewModel = CartDeleteViewModel(dataStore: dataStore)
        let viewController = CartDeleteItemViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCartPaymentMethodScreenView(networkClient: NetworkClient,
                                         dataStore: CartDataStorageProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol {
        let viewModel = CartPaymentMethodViewModel(networkClient: networkClient, dataStore: dataStore)
        let dataSource = CollectionViewDataSourceManager()
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
