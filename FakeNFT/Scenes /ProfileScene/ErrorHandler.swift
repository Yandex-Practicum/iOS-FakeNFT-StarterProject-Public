//
//  ErrorHandler.swift
//  FakeNFT
//
//  Created by Илья Валито on 05.07.2023.
//

import UIKit

// MARK: - ErrorHandlerDelegate protocol
protocol ErrorHandlerDelegate: AnyObject {
    func proceedError()
}

// MARK: - ErrorHandler
struct ErrorHandler {
    // MARK: - PropertiesAndInitializers
    var delegate: ErrorHandlerDelegate?

    func giveAlert(withMessage message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "SOMETHING_WENT_WRONG".localized,
                                                message: message,
                                                preferredStyle: .alert)

        let retryAction = UIAlertAction(title: "RETRY".localized,
                                        style: .default) { _ in
            delegate?.proceedError()
        }

        let cancelAction = UIAlertAction(title: "CANCEL".localized,
                                         style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        return alertController
    }
}
