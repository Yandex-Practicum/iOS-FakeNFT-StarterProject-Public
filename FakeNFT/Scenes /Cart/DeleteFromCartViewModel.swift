//
//  DeleteFromCartViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//


import Combine
import Foundation

final class DeleteFromCartViewModel: ObservableObject {
    @Published var nft: Nft
    @Published var imageURL: URL?
    
    var confirmDeletion = PassthroughSubject<Void, Never>()
    
    init(nft: Nft, imageURL: URL?) {
        self.nft = nft
        self.imageURL = imageURL
    }
    
    func confirmDelete() {
        confirmDeletion.send()
    }
}

