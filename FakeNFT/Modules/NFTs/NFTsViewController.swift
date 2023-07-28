//
//  NFTsViewController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

final class NFTsViewController: UIViewController {
    private let viewModel: NFTsViewModel
    
    init(viewModel: NFTsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NFTsViewController -> init(coder:) has not been impl")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    private func configureController() {
        view.backgroundColor = .appWhite
    }
}
