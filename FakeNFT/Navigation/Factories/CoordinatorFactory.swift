//
//  CoordinatorFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func makeTabBarCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeCatalogCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeCartCoordinator(with router: Routable) -> CoordinatorProtocol
}

final class CoordinatorFactory  {
    private let modulesFactory: ModulesFactoryProtocol = ModulesFactory()
    private let navigationControllerFactory: NavigationControllerFactoryProtocol = NavigationControllerFactory()
    private let alertConstructor: AlertConstructable = AlertConstructor()
    private let dataStore: DataStorageProtocol & PaymentMethodStorageProtocol = DataStore()
}

extension CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeTabBarCoordinator(with router: Routable) -> CoordinatorProtocol {
        TabBarCoordinator(
            factory: self,
            router: router) // создаем корневой координатор для управления модулями
    }
    
    func makeCatalogCoordinator(with router: Routable) -> CoordinatorProtocol {
        // создаем координатор модуля для настройки экрана, иконки таббара и всего остального
        CatalogCoordinator(
            factory: modulesFactory,
            router: router,
            navigationControllerFactory: navigationControllerFactory)
    }
    
    func makeCartCoordinator(with router: Routable) -> CoordinatorProtocol {
        // создаем координатор модуля для настройки экрана, иконки таббара и всего остального
        CartCoordinator(
            factory: modulesFactory,
            router: router,
            navigationControllerFactory: navigationControllerFactory,
            alertConstructor: alertConstructor,
            dataStore: dataStore
        )
    }
    
    // MARK: Инструкция по созданию модулей
    // Для создания нового модуля нужно добавить сюда метод создания нового координатора
    // Координатор должен иметь фабрику модулей, роутер и фабрику навигационных контроллеров
    // Дальше нужно перейти в TabBarCoordinator, создать там метод создания нового ScreenView по аналогии с уже имеющимися и добавить его в метод start() TabBarCoordinator'а
    // Затем в ModulesFactory необходимо создать новый метод с созданием нужного экрана и добавить его в протокол
    // В новом координаторе создать метод createScreen()
    // Прописать реализацию метода createScreen() - создание самого экрана через ModulesFactory, добавление его в навигационный стек через NavControllerFactory и финальное добавление навигационного контроллера в таббар через router.addTabBarItem
    // Дальше можно работать только в нужном координаторе, все настройка, все реакции на события будут обрабатываться там
}
