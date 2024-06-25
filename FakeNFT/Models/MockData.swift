//
//  MockData.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import Foundation

struct MockData {
    static func createMockNFTs() -> [Nft] {
        guard let aprilURL = URL(
            string: "card_april"
        ),
              let greenaURL = URL(
                string: "card_greena"
              ),
              let springURL = URL(
                string: "card_spring"
              ) else {
            
            return []
        }
        
        return [
            Nft(
                id: "1",
                name: "April",
                images: [aprilURL],
                rating: 3,
                description: "Description for April",
                price: 1.78,
                author: "Author 1",
                createdAt: "2023-10-19T06:08:33.207Z[GMT]"
            ),
            Nft(
                id: "2",
                name: "Greena",
                images: [greenaURL],
                rating: 2,
                description: "Description for Greena",
                price: 1.78,
                author: "Author 2",
                createdAt: "2023-10-20T10:23:01.305Z[GMT]"
            ),
            Nft(
                id: "3",
                name: "Spring",
                images: [springURL],
                rating: 1,
                description: "Description for Spring",
                price: 1.78,
                author: "Author 3",
                createdAt: "2023-09-27T23:48:21.462Z[GMT]"
            )
        ]
    }
}
