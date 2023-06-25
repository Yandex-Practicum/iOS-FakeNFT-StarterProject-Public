//
//  NFTDetailsViewController.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

class NFTDetailsViewController: UIViewController {

    private let viewModel: NFTDetailsViewModel
    private lazy var container = NFTDetailsContainerView(details: viewModel.details)

    init(viewModel: NFTDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = container
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
