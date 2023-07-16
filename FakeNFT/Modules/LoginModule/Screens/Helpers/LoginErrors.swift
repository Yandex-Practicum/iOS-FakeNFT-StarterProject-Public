//
//  LoginErrors.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import Foundation

enum LoginErrors {
    case invalidData, userExists, textFieldEmpty, internalError
    
    var message: String {
        switch self {
        case .invalidData:
            return K.LogInErrors.invalidData
        case .userExists:
            return K.LogInErrors.userExists
        case .textFieldEmpty:
            return K.LogInErrors.textFieldEmpty
        case .internalError:
            return K.LogInErrors.internalError
        }
    }
}
