//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 17.08.2023.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?
    
    func injectDelegate(viewController: UIViewController) {
        delegate = viewController
    }
    
    /// Метод, в который передаются модели действия - AlertActionModel, которые будут представлены в алерте. Действие закрытия алерта уже добавлено.
    func didTapSortButton(models: [AlertActionModel]) {
        let alert = UIAlertController(
            title: NSLocalizedString("sorting.name", comment: "Заголовок алерта сортировки"),
            message: nil,
            preferredStyle: .actionSheet)
        
        for model in models {
            let action = UIAlertAction(title: model.buttonText, style: model.style) { _ in
                model.completion()
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("sorting.close", comment: "Закрытие алерта сортировки"),
            style: .cancel)
        alert.addAction(cancelAction)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
