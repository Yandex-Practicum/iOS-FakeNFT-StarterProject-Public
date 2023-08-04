//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: GenericTableViewDataSourceProtocol,
                               dataStore: DataStorageManagerProtocol,
                               networkClient: PublishersFactoryProtocol) -> Presentable & CatalogMainScreenCoordinatable & Reloadable
    func makeCatalogCollectionScreenView(with collection: CatalogMainScreenCollection,
                                         dataSource: GenericCollectionViewDataSourceProtocol & CollectionViewDataSourceCoordinatable,
                                         dataStore: DataStorageManagerProtocol,
                                         networkClient: PublishersFactoryProtocol) -> Presentable & CatalogCollectionCoordinatable & Reloadable
    func makeCatalogWebViewScreenView(with address: String) -> Presentable & WebViewProtocol
}

protocol CartModuleFactoryProtocol {
    func makeCartScreenView(dataSource: GenericTableViewDataSourceProtocol & TableViewDataSourceCoordinatable,
                            dataStore: DataStorageManagerProtocol) -> Presentable & CartMainCoordinatableProtocol
    func makeCartDeleteScreenView(dataStore: DataStorageManagerProtocol) -> Presentable & CartDeleteCoordinatableProtocol
    func makeCartPaymentMethodScreenView(dataSource: GenericCollectionViewDataSourceProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol
    func makePaymentResultScreenView(request: NetworkRequest?, dataStore: DataStorageManagerProtocol) -> Presentable & PaymentResultCoordinatable
    func makeCartWebViewScreenView() -> Presentable & WebViewProtocol
}

protocol LoginModuleFactoryProtocol {
    func makeLoginScreenView(keyChainManager: SecureDataProtocol) -> Presentable & LoginMainCoordinatableProtocol
    func makeResetPasswordScreenView(keyChainManager: SecureDataProtocol) -> Presentable & ResetPasswordCoordinatable
}

protocol OnboardingModuleFactoryProtocol {
    func makeOnboardingScreenView() -> Presentable & OnboardingCoordinatable
}

protocol ProfileModuleFactoryProtocol {
    func makeProfileMainScreenView(with dataSource: GenericTableViewDataSourceProtocol,
                                   dataStorage: DataStorageManagerProtocol,
                                   networkClient: PublishersFactoryProtocol) -> Presentable & ProfileMainCoordinatableProtocol & Reloadable
    
    func makeProfileMyNftsScreenView(with dataSource: GenericTableViewDataSourceProtocol,
                                     nftsToLoad: [String],
                                     dataStore: DataStorageManagerProtocol,
                                     networkClient: PublishersFactoryProtocol) -> Presentable & ProfileMyNftsCoordinatable & Reloadable
    
    func makeProfileLikedNftsScreenView(with dataSource: GenericCollectionViewDataSourceProtocol,
                                        dataStore: DataStorageManagerProtocol,
                                        networkClient: PublishersFactoryProtocol) -> Presentable & ProfileLikedCoordinatable & Reloadable
}

final class ModulesFactory {}

// MARK: - Ext OnboardingModuleFactoryProtocol
extension ModulesFactory: OnboardingModuleFactoryProtocol {
    func makeOnboardingScreenView() -> Presentable & OnboardingCoordinatable {
        let viewModel = OnboardingViewModel()
        let viewController = OnboardingPageViewController(transitionStyle: .scroll,navigationOrientation: .horizontal)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: - Ext LoginModuleFactoryProtocol
extension ModulesFactory: LoginModuleFactoryProtocol {
    func makeLoginScreenView(keyChainManager: SecureDataProtocol) -> Presentable & LoginMainCoordinatableProtocol {
        let networkClient = DefaultNetworkClient()
        let viewModel = LoginMainScreenViewModel(networkClient: networkClient, keyChainManager: keyChainManager)
        let viewController = LoginMainScreenViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeResetPasswordScreenView(keyChainManager: SecureDataProtocol) -> Presentable & ResetPasswordCoordinatable {
        let viewModel = ResetPasswordViewModel(keyChainManager: keyChainManager)
        let viewController = ResetPasswordViewController(viewModel: viewModel)
        return viewController
    }
}

// MARK: - Ext ProfileModuleFactoryProtocol
extension ModulesFactory: ProfileModuleFactoryProtocol {
    func makeProfileMainScreenView(with dataSource: GenericTableViewDataSourceProtocol,
                                   dataStorage: DataStorageManagerProtocol,
                                   networkClient: PublishersFactoryProtocol) -> Presentable & ProfileMainCoordinatableProtocol & Reloadable {
        let viewModel = ProfileMainViewModel(networkClient: networkClient, dataStorage: dataStorage)
        let viewController = ProfileMainViewController(viewModel: viewModel, dataSource: dataSource)
        return viewController
    }
    
    func makeProfileMyNftsScreenView(with dataSource: GenericTableViewDataSourceProtocol,
                                     nftsToLoad: [String],
                                     dataStore: DataStorageManagerProtocol,
                                     networkClient: PublishersFactoryProtocol) -> Presentable & ProfileMyNftsCoordinatable & Reloadable {
        let viewModel = ProfileMyNftsViewModel(networkClient: networkClient, nftsToLoad: nftsToLoad, dataStore: dataStore)
        let viewController = ProfileMyNftsViewController(viewModel: viewModel, dataSource: dataSource)
        return viewController
    }
    
    func makeProfileLikedNftsScreenView(with dataSource: GenericCollectionViewDataSourceProtocol,
                                        dataStore: DataStorageManagerProtocol,
                                        networkClient: PublishersFactoryProtocol) -> Presentable & ProfileLikedCoordinatable & Reloadable {
        let viewModel = ProfileLikedNftsViewModel(networkClient: networkClient, dataStore: dataStore)
        let viewController = ProfileLikedNftsViewController(viewModel: viewModel, dataSource: dataSource)
        return viewController
    }
}

// MARK: - Ext CatalogModuleFactoryProtocol
extension ModulesFactory: CatalogModuleFactoryProtocol {
    func makeCatalogScreenView(dataSource: GenericTableViewDataSourceProtocol,
                               dataStore: DataStorageManagerProtocol, networkClient: PublishersFactoryProtocol) -> Presentable & CatalogMainScreenCoordinatable & Reloadable {
        let viewModel = CatalogViewModel(dataStore: dataStore, networkClient: networkClient)
        return CatalogViewController(dataSource: dataSource, viewModel: viewModel)
    }
    
    func makeCatalogCollectionScreenView(with collection: CatalogMainScreenCollection,
                                         dataSource: GenericCollectionViewDataSourceProtocol & CollectionViewDataSourceCoordinatable,
                                         dataStore: DataStorageManagerProtocol, networkClient: PublishersFactoryProtocol) -> Presentable & CatalogCollectionCoordinatable & Reloadable {
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
                            dataStore: DataStorageManagerProtocol) -> Presentable & CartMainCoordinatableProtocol {
        let networkClient = DefaultNetworkClient()
        let viewModel = CartViewModel(dataStore: dataStore, networkClient: networkClient)
        let viewController = CartViewController(dataSource: dataSource, viewModel: viewModel)
        
        return viewController
    }
    
    func makeCartDeleteScreenView(dataStore: DataStorageManagerProtocol) -> Presentable & CartDeleteCoordinatableProtocol {
        let viewModel = CartDeleteViewModel(dataStore: dataStore)
        let viewController = CartDeleteItemViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCartPaymentMethodScreenView(dataSource: GenericCollectionViewDataSourceProtocol) -> Presentable & CartPaymentMethodCoordinatableProtocol {
        let networkClient = DefaultNetworkClient()
        let viewModel = CartPaymentMethodViewModel(networkClient: networkClient)
        let viewController = CartPaymentMethodViewController(viewModel: viewModel, dataSource: dataSource)
        return viewController
    }
    
    func makePaymentResultScreenView(request: NetworkRequest?, dataStore: DataStorageManagerProtocol) -> Presentable & PaymentResultCoordinatable {
        let networkClient = DefaultNetworkClient()
        let viewModel = CartPaymentResultViewModel(networkClient: networkClient, dataStore: dataStore)
        viewModel.request = request
        let viewController = CartPaymentResultViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCartWebViewScreenView() -> Presentable & WebViewProtocol {
        let viewController = WebViewController(webViewUrlSource: .licence)
        return viewController
    }
}
