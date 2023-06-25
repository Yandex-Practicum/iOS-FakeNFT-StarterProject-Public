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
            return NSLocalizedString("Успех! Оплата прошла,\n поздравляем с покупкой!", comment: "")
        case .failure:
            return NSLocalizedString("Упс! Что-то пошло не так :(\n Попробуйте ещё раз!", comment: "")
        case .loading:
            return NSLocalizedString("Ваша покупка обрабатывается, пожалуйста, ожидайте", comment: "")
        }
    }
    
    var buttonTitle: String? {
        switch self {
        case .success:
            return NSLocalizedString("Вернуться в каталог", comment: "")
        case .failure:
            return NSLocalizedString("Попробовать еще раз", comment: "")
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
}
