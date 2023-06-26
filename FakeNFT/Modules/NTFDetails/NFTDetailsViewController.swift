//
//  NFTDetailsViewController.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

class NFTDetailsViewController: UIViewController {

    private let viewModel: NFTDetailsViewModel
    private lazy var container = NFTDetailsContainerView(details: viewModel.details) { [weak self] event in
            guard let self else { return }
            switch event {
            case let .selectFavourite(index):
                self.viewModel.addTofavouriteNft(index: index)
            case let .unselectFavourite(index):
                self.viewModel.removeFromFavouriteNft(index: index)
            case let .selectBasket(index):
                self.viewModel.selectNft(index: index)
            case let .unselectBasket(index):
                self.viewModel.unselectNft(index: index)
            }
        }

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.backgroundColor = .clear
        //        self.navigationController?.navigationBar.isTranslucent = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        //        self.navigationController?.navigationBar.shadowImage = nil
        //        self.navigationController?.navigationBar.isTranslucent = false
        //        self.navigationController?.navigationBar.backgroundColor = .appWhite
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.backgroundColor = .appWhite
    }
}
