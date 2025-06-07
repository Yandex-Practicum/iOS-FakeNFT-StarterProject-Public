//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

@MainActor
final class UserCollectionViewModel: ObservableObject {
    @Published var nftIds: [String]

    init(nftIds: [String]) {
        self.nftIds = nftIds
    }
}
