//
//  NFTSortingAlertController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import UIKit

final class NFTSortingAlertController: UIAlertController {
    private let viewModel: NFTSortingViewModel
    
    init(viewModel: NFTSortingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(
            "NFTSortingAlertController -> init(coder:) has not been implemented"
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    private func setupSubViews() {
        title = "TITLE_SORT".localized
        addAction(
            UIAlertAction(
                title: "SORT_BY_NAME".localized,
                style: .default
            ) { [weak self] _ in
            guard let self else { return }
            self.viewModel.sorting(by: .name)
        })
        addAction(
            UIAlertAction(
                title: "SORT_BY_AMOUNT".localized,
                style: .default
            ) { [weak self] _ in
            guard let self else { return }
            self.viewModel.sorting(by: .number)
        })
        addAction(
            UIAlertAction(
                title: "CLOSE_ALERT_TITLE".localized,
                style: .cancel,
                handler: nil)
        )
    }
}
