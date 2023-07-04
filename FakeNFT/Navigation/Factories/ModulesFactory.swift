//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: CatalogDataSourceManagerProtocol,
                               dataStore: CatalogDataStorageProtocol) -> Presentable & CatalogMainScreenCoordinatable
    func makeCatalogCollectionScreenView(with collection: NftCollection,
                                         dataSource: NftCollectionDSManagerProtocol) -> Presentable & CatalogCollectionCoordinatable
}

protocol CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: CartDataSourceManagerProtocol, dataStore: CartDataStorageProtocol) -> Presentable & CartMainCoordinatableProtocol
    func makeCartDeleteScreenView(dataStore: CartDataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol
    func makeCartPaymentMethodScreenView(dataStore: CartDataStorageProtocol,
                                         dataSource: PaymentMethodDSManagerProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol
    func makePaymentResultScreenView(request: NetworkRequest?) -> Presentable & PaymentResultCoordinatable
    func makeCartWebViewScreenView() -> Presentable & WebViewProtocol
}

final class ModulesFactory {}

// MARK: - Ext CatalogModuleFactoryProtocol
extension ModulesFactory: CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: CatalogDataSourceManagerProtocol,
                               dataStore: CatalogDataStorageProtocol) -> Presentable & CatalogMainScreenCoordinatable {
        let networkClient = DefaultNetworkClient()
        let viewModel = CatalogViewModel(dataStore: dataStore, networkClient: networkClient)
        return CatalogViewController(dataSource: dataSource, viewModel: viewModel)
    }
    
    func makeCatalogCollectionScreenView(with collection: NftCollection, dataSource: NftCollectionDSManagerProtocol) -> Presentable & CatalogCollectionCoordinatable {
        let networkClient = DefaultNetworkClient()
        let viewModel = CatalogCollectionViewModel(nftCollection: collection, networkClient: networkClient)
        let viewController = CatalogCollectionViewController(viewModel: viewModel, diffableDataSource: dataSource)
        return viewController
    }
}

// MARK: - Ext CartModuleFactoryProtocol
extension ModulesFactory: CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: CartDataSourceManagerProtocol,
                            dataStore: CartDataStorageProtocol) -> Presentable & CartMainCoordinatableProtocol {
        let networkClient = DefaultNetworkClient()
        let viewModel = CartViewModel(dataStore: dataStore, networkClient: networkClient)
        let viewController = CartViewController(dataSource: dataSource, viewModel: viewModel)
        
        return viewController
    }
    
    func makeCartDeleteScreenView(dataStore: CartDataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol {
        let viewModel = CartDeleteViewModel(dataStore: dataStore)
        let viewController = CartDeleteItemViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCartPaymentMethodScreenView(dataStore: CartDataStorageProtocol,
                                         dataSource: PaymentMethodDSManagerProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol {
        let networkClient = DefaultNetworkClient()
        let viewModel = CartPaymentMethodViewModel(networkClient: networkClient, dataStore: dataStore)
        let viewController = CartPaymentMethodViewController(viewModel: viewModel, dataSource: dataSource)
        return viewController
    }
    
    func makePaymentResultScreenView(request: NetworkRequest?) -> Presentable & PaymentResultCoordinatable {
        let networkClient = DefaultNetworkClient()
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
