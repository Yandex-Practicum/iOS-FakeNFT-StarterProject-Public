//
//  AlertErrorActions.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 08.07.2023.
//

import UIKit

enum AlertErrorActions: CaseIterable {
    case reload, leave
    
    var title: String {
        switch self {
        case .reload:
            return K.Titles.tryAgain
        case .leave:
            return K.Titles.leaveAsItIs
        }
    }
    
    var action: UIAlertAction.Style {
        switch self {
        case .reload:
            return .default
        case .leave:
            return .cancel
        }
    }
}
