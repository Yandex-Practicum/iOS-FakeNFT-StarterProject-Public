//
//  NFTInfoFactory.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import UIKit

struct NFTInfoFactory {
    static func create(info: NFTInfo) -> UIViewController {
        return NFTInfoViewController(
            viewModel: NFTInfoViewModelImpl(
                storage: NFtStorageServiceImpl(
                    storageService: UserDefaultsStorageService()
                ),
                details: info
            )
        )
    }
}
