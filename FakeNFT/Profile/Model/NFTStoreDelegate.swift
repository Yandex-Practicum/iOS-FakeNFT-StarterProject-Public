//
//  NFTStoreDelegate.swift
//  FakeNFT
//

import Foundation

protocol NFTStoreDelegate: AnyObject {
    func didReceive(_ nftModel: NFTModel)
    func didReceive(_ сollections: [CollectionModel])
    func didReceive(_ userModel: AuthorModel)
}
