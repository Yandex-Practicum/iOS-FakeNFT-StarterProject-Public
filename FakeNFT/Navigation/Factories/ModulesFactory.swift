//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: GenericTableViewDataSourceProtocol,
                               dataStore: CatalogDataStorageProtocol) -> Presentable & CatalogMainScreenCoordinatable
    func makeCatalogCollectionScreenView(with collection: NftCollection,
                                         dataSource: GenericDataSourceManagerProtocol & CollectionViewDataSourceCoordinatable,
                                         dataStore: CatalogDataStorageProtocol) -> Presentable & CatalogCollectionCoordinatable
    func makeCatalogWebViewScreenView(with address: String) -> Presentable & WebViewProtocol
}

protocol CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: GenericTableViewDataSourceProtocol & TableViewDataSourceCoordinatable,
                            dataStore: CartDataStorageProtocol) -> Presentable & CartMainCoordinatableProtocol
    func makeCartDeleteScreenView(dataStore: CartDataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol
    func makeCartPaymentMethodScreenView(dataStore: CartDataStorageProtocol,
                                         dataSource: GenericDataSourceManagerProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol
    func makePaymentResultScreenView(request: NetworkRequest?) -> Presentable & PaymentResultCoordinatable
    func makeCartWebViewScreenView() -> Presentable & WebViewProtocol
}

protocol LoginModuleFactoryProtocol {
    func makeLoginScreenView() -> Presentable & LoginMainCoordinatableProtocol
}

final class ModulesFactory {}

// MARK: - Ext LoginModuleFactoryProtocol
extension ModulesFactory: LoginModuleFactoryProtocol {
    func makeLoginScreenView() -> Presentable & LoginMainCoordinatableProtocol {
        let networkClient = DefaultNetworkClient()
        let viewModel = LoginMainScreenViewModel(networkClient: networkClient)
        let viewController = LoginMainScreenViewController(viewModel: viewModel)
        return viewController
    }
}

// MARK: - Ext CatalogModuleFactoryProtocol
extension ModulesFactory: CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: GenericTableViewDataSourceProtocol,
                               dataStore: CatalogDataStorageProtocol) -> Presentable & CatalogMainScreenCoordinatable {
        let networkClient = DefaultNetworkClient()
        let viewModel = CatalogViewModel(dataStore: dataStore, networkClient: networkClient)
        return CatalogViewController(dataSource: dataSource, viewModel: viewModel)
    }
    
    func makeCatalogCollectionScreenView(with collection: NftCollection,
                                         dataSource: GenericDataSourceManagerProtocol & CollectionViewDataSourceCoordinatable,
                                         dataStore: CatalogDataStorageProtocol) -> Presentable & CatalogCollectionCoordinatable {
        let networkClient = DefaultNetworkClient()
        let viewModel = CatalogCollectionViewModel(nftCollection: collection, networkClient: networkClient, dataStore: dataStore)
        let viewController = CatalogCollectionViewController(viewModel: viewModel, diffableDataSource: dataSource)
        return viewController
    }
    
    func makeCatalogWebViewScreenView(with address: String) -> Presentable & WebViewProtocol {
        let viewController = WebViewController(webViewUrlSource: .author)
        viewController.website = address
        return viewController
    }
}

// MARK: - Ext CartModuleFactoryProtocol
extension ModulesFactory: CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: GenericTableViewDataSourceProtocol & TableViewDataSourceCoordinatable,
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
                                         dataSource: GenericDataSourceManagerProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol {
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
        let viewController = WebViewController(webViewUrlSource: .licence)
        return viewController
    }
}
