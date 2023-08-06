//
//  Alert.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import Foundation

protocol AlertViewModel {
    var title: String? { get }
    var message: String? { get }
    var actions: [ActionModel] { get }
}

struct AlertViewModelImpl: AlertViewModel {
    let title: String?
    let message: String?
    let actions: [ActionModel]
}

struct ActionModel {
    let title: String
    let style: AlertActionStyle
    let handler: (() -> Void)?
}

enum AlertActionStyle {
    case `default`
    case cancel
    case destructive
}
