//
//  TrashViewController.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 09.02.2024.
//

import UIKit

protocol TrashViewProtocol: AnyObject {
    func updateUI(with model: TrashView.Model)
}

final class TrashViewController: UIViewController {
    private let presenter: TrashPresenterProtocol
    
    private let customView = TrashView()
    
    init(presenter: TrashPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        presenter.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - TrashViewProtocol

extension TrashViewController: TrashViewProtocol {
    func updateUI(with model: TrashView.Model) {
        customView.configure(with: model)
    }
}
