//
//  RequestResult.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 25.06.2023.
//

import UIKit

enum RequestResult {
    case success, failure, loading
    
    var description: String {
        switch self {
        case .success:
            return K.Titles.successfulPurchase
        case .failure:
            return K.Titles.unSuccessfulPurchase
        case .loading:
            return K.Titles.loadingData
        }
    }
    
    var buttonTitle: String? {
        switch self {
        case .success:
            return K.Titles.backToCatalog
        case .failure:
            return K.Titles.tryAgain
        case .loading:
            return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: K.Icons.checkmark)
        case .failure:
            return UIImage(systemName: K.Icons.xmark)
        case .loading:
            return UIImage(systemName: K.Icons.circleDotted)
        }
    }
    
    var passwordResetTextColor: UIColor {
        switch self {
        case .success:
            return .universalGreen
        case .failure:
            return .universalRed
        case .loading:
            return .ypBlack ?? .universalGreen
        }
    }
    
    var passwordResetResultMessage: String? {
        switch self {
        case .success:
            return K.PasswordResetMessages.passwordResetSuccess
        case .failure:
            return K.PasswordResetMessages.passwordResetFailure
        case .loading:
            return nil
        }
    }
}
