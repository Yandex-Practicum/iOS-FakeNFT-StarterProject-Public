//
//  CartRemoveNftViewFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import UIKit.UIImage

struct CartRemoveNftViewFactory {
    private let nftImage: UIImage?

    init(nftImage: UIImage?) {
        self.nftImage = nftImage
    }

    func create(
        onChoosingRemoveNft: @escaping (CartRemoveNftViewController.RemoveNftFlow) -> Void
    ) -> CartRemoveNftViewController {
        let removeNftViewController = CartRemoveNftViewController(nftImage: self.nftImage)
        removeNftViewController.onChoosingRemoveNft = onChoosingRemoveNft

        removeNftViewController.modalPresentationStyle = .overFullScreen
        removeNftViewController.modalTransitionStyle = .crossDissolve

        return removeNftViewController
    }
}
