//
//  ActionType.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import Foundation

enum ActionType {
    case login, register
    
    var hiddenState: Bool {
        switch self {
        case .login:
            return false
        case .register:
            return true
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .login:
            return K.Titles.loginButtonTitle
        case .register:
            return K.Titles.registerButtonTitle
        }
    }
}
