//
//  AlertPresenterProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 17.08.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    func injectDelegate(viewController: UIViewController)
    func didTapSortButton(models: [AlertActionModel])
}
