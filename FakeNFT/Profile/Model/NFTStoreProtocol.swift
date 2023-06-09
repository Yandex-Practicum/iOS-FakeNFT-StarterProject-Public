//
//  NFTStoreProtocol.swift
//  FakeNFT
//

import Foundation

protocol NFTStoreProtocol {
    func getNFTs(using nftIDs: [Int], callback: @escaping ((Result<NFTModel, Error>) -> Void))
}
