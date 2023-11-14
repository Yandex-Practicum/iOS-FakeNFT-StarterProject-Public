//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit

final class AlertPresenter {
    
    private init() {}
    
    static func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: nil,
            message: model.message,
            preferredStyle: .actionSheet)
        
        let nameSort = UIAlertAction(title: model.nameSortText, style: .default) { _ in
            model.sortNameCompletion()
        }
        
        alert.addAction(nameSort)
        
        let quantitySort = UIAlertAction(title: model.quantitySortText, style: .default) { _ in
            model.sortQuantityCompletion()
        }
        
        alert.addAction(quantitySort)
        
        let cancelAction = UIAlertAction(title: model.cancelButtonText, style: .cancel)
        
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true)
    }
    
    static func showError(in vc: UIViewController, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: "Network error", message: "Try again?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
