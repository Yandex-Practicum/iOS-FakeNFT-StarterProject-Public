//
//  NFTCollectionModel.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 4/3/25.
//
import UIKit

struct NFTCollectionModel {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
    
    init(createdAt: String, name: String, images: [String], rating: Int, description: String, price: Float, author: String, id: String) {
        self.createdAt = createdAt
        self.name = name
        self.images = images
        self.rating = rating
        self.description = description
        self.price = price
        self.author = author
        self.id = id
    }
    
    init(result nft: NFTCollectionResult) {
        self.createdAt = nft.createdAt
        self.name = nft.name
        self.images = nft.images
        self.rating = nft.rating
        self.description = nft.description
        self.price = nft.price
        self.author = nft.author
        self.id = nft.id
    }
}

struct NFTCollectionResult: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
