//
//  HandlingErrorService.swift
//  FakeNFT
//
//  Created by Евгений on 13.08.2023.
//

import Foundation

final class HandlingErrorService {
    func handlingHTTPStatusCodeError(error: Error) -> String? {
        guard let error = error as? NetworkClientError else { return nil }
        
        switch error {
        case .httpStatusCode(let code):
            switch  code {
            case 404:
                return L10n.NetworkError.Http._404
            case 409:
                return L10n.NetworkError.Http._409
            case 410:
                return L10n.NetworkError.Http._410
            case 500...526:
                return L10n.NetworkError.Http._5Хх
            default:
                return L10n.NetworkError.anotherError
            }
            
        case .parsingError:
            return L10n.NetworkError.parsingError
        case .urlRequestError:
            return  L10n.NetworkError.requestError
        case .urlSessionError:
            return L10n.NetworkError.urlSessionError
        }
    }
}
