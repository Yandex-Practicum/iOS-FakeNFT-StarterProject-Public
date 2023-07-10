//
//  NFTCollectionNetworkService.swift
//  FakeNFT
//
//  Created by Kirill on 10.07.2023.
//

import Foundation

protocol NFTNetworkService {
    func getCollectionNFT(result: @escaping (Result<NFTCollectionResponse, Error>) -> Void)
    func getIndividualNFT(result: @escaping (Result<NFTIndividualResponse, Error>) -> Void)
}

