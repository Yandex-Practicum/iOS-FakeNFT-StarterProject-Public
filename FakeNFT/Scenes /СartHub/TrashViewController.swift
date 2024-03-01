//
//  TrashViewController.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 09.02.2024.
//

import UIKit

protocol TrashViewProtocol: AnyObject {
    
}

final class TrashViewController: UIViewController {
    let presenter: TrashPresenter
    
    init(presenter: TrashPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - TrashViewProtocol

extension TrashViewController: TrashViewProtocol {
    
}
