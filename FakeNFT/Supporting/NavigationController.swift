//
//  NavigationController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

final class NavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NavigationController: init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureNavigationController() {
        navigationBar.tintColor = .appBlack
        navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(style: .bold, size: 17),
            .foregroundColor: UIColor.appBlack
        ]
    }
}
