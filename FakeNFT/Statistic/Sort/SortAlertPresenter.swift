//
//  SortAlertController.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/15/25.
//
import UIKit

struct SortAlertPresenter {
    static func present(
        title: String?,
        message: String,
        actions: UIAlertAction...,
        from controller: UIViewController
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
        for action in actions {
            alertController.addAction(action)
        }
            
        controller.present(alertController, animated: true, completion: nil)
    }
    static func createAction(title: String,
                             style: UIAlertAction.Style,
                             handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}
