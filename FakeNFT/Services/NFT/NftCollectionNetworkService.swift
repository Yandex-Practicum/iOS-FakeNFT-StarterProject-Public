//
//  NftCollectionNetworkService.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//
import Foundation

protocol NFTNetworkService {
    func getNFTCollection(
        result: @escaping ResultHandler<NFTCollectionResponse>
    )

    func getNFTItem(
        result: @escaping ResultHandler<NFTItemResponse>
    )
}

public protocol NFTNetworkCartService {
    func getNFTItemBy(
        id: String,
        result: @escaping ResultHandler<NFTItemModel>
    )
}
