//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

protocol CoordinatableProtocol {
    // передача универсальных событий в координатор: returnOnCancel, returnOnSuccess etc.
}

protocol ModulesFactoryProtocol {
    func makeCatalogScreenView() -> UIViewController // TODO: потом заменить на протокол CoordinatableProtocol
    func makeCartScreenView() -> UIViewController // TODO: потом заменить на протокол CoordinatableProtocol
    
    // TODO: добавить два метода с основными экранами - профиль и статистика
    
    // Здесь создаем основной экран модуля таббара, затем здесь же можно создавать экраны для дальнейших переходов в рамках модуля
    
}

// MARK: Инъекция зависимостей тут
final class ModulesFactory: ModulesFactoryProtocol {
    func makeCatalogScreenView() -> UIViewController {
        // можно настроить экран перед созданием - все зависимые свойства, делегаты и пр.
        return CatalogViewController()
    }
    
    func makeCartScreenView() -> UIViewController {
        // можно настроить экран перед созданием - все зависимые свойства, делегаты и пр.
        return CartViewController()
    }
    
    
}
