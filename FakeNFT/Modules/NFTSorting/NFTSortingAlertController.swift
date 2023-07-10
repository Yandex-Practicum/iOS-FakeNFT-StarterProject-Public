//
//  NFTSortingAlertController.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import UIKit

final class NFTSortingAlertController: UIAlertController {

    private let viewModel: NFTSortingViewModel

    init(viewModel: NFTSortingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }

    private func setupSubViews() {
        title = "Сортировка"
        addAction(UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            guard let self else { return }
            self.viewModel.sorting(by: .name)
        })
        addAction(UIAlertAction(title: "По коливчеству NFT", style: .default) { [weak self] _ in
            guard let self else { return }
            self.viewModel.sorting(by: .amount)
        })
        addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
    }
}

