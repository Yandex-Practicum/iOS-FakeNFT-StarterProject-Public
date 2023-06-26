//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

protocol ModulesFactoryProtocol {
    func makeCatalogScreenView() -> UIViewController // TODO: потом заменить на протокол CoordinatableProtocol
    func makeCartScreenView(dataStore: DataStorageProtocol, networkClient: NetworkClient) -> Presentable & CartMainCoordinatableProtocol
    func makeCartDeleteScreenView(dataStore: DataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol
    func makeCartPaymentMethodScreenView(networkClient: NetworkClient) -> Presentable & CartPaymentMethodCoordinatableProtocol
    func makePaymentResultScreenView(networkClient: NetworkClient, request: NetworkRequest?) -> Presentable & PaymentResultCoordinatable
    func makeCartWebViewScreenView() -> Presentable & WebViewProtocol
    // TODO: добавить два метода с основными экранами - профиль и статистика
    
    // Здесь создаем основной экран модуля таббара, затем здесь же можно создавать экраны для дальнейших переходов в рамках модуля
    
}

// MARK: Инъекция зависимостей тут
final class ModulesFactory: ModulesFactoryProtocol {
    func makeCatalogScreenView() -> UIViewController {
        // можно настроить экран перед созданием - все зависимые свойства, делегаты и пр.
        return CatalogViewController()
    }
    
    func makeCartScreenView(dataStore: DataStorageProtocol, networkClient: NetworkClient) -> Presentable & CartMainCoordinatableProtocol {
        // можно настроить экран перед созданием - все зависимые свойства, делегаты и пр.
        let dataSource = CartDataSourceManager()
        let viewModel = CartViewModel(dataStore: dataStore, networkClient: networkClient)
        let viewController = CartViewController(dataSource: dataSource, viewModel: viewModel)
        dataSource.delegate = viewController
        return viewController
    }
    
    func makeCartDeleteScreenView(dataStore: DataStorageProtocol) -> Presentable & CartDeleteCoordinatableProtocol {
        let viewModel = CartDeleteViewModel(dataStore: dataStore)
        let viewController = CartDeleteItemViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCartPaymentMethodScreenView(networkClient: NetworkClient) -> Presentable & CartPaymentMethodCoordinatableProtocol {
        let viewModel = CartPaymentMethodViewModel(networkClient: networkClient)
        let dataSource = PaymentMethodDataSourceManager()
        let viewController = CartPaymentMethodViewController(viewModel: viewModel, dataSource: dataSource)
        return viewController
    }
    
    func makePaymentResultScreenView(networkClient: NetworkClient, request: NetworkRequest?) -> Presentable & PaymentResultCoordinatable {
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
