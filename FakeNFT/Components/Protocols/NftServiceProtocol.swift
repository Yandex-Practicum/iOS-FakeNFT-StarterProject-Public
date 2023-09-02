//
//  NftServiceProtocol.swift
//  FakeNFT
//
//  Created by MacBook on 01.09.2023.
//

protocol NftServiceProtocol {
    func getNftList(nftIds: [Int], onCompletion: @escaping (Result<[NFTCard], Error>) -> Void)
    func getNft(nftId: Int, onCompletion: @escaping (Result<NFTCard, Error>) -> Void)
}
