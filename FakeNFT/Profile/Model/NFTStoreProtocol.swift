//
//  NFTStoreProtocol.swift
//  FakeNFT
//

import Foundation

protocol NFTStoreProtocol {
    var delegate: NFTStoreDelegate? { get set }
    func get(_ nfts: [Int])
    func getСollections()
    func getNames(for authorIDs: [AuthorViewModel])
}
