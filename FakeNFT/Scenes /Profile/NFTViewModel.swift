//
//  UserNftViewModel.swift
//  FakeNFT
//
//  Created by Mac on 18.06.2025.
//

import SwiftUI

@MainActor
final class NFTViewModel: ObservableObject {
    enum SortOption: String, CaseIterable, Identifiable {
        case name = "По названию"
        case price = "По цене"
        case rating = "По рейтингу"
        
        var id: String { rawValue }
    }
     
       @Published var isShowingFilterSheet: Bool = false
       @Published var allNFTs: [NFT] = MockNFTData.sampleNFTs
       @Published var likedNFTs: [NFT] = []

    @AppStorage("selectedSortOption") private var storedSortOption: String = SortOption.name.rawValue
    
    
    

    var selectedSortOption: SortOption {
        get{ SortOption(rawValue: storedSortOption) ?? .name}
        set { storedSortOption = newValue.rawValue }
    }
    
   
    var sortedNFTs: [NFT] {
        switch selectedSortOption {
        case .name:
            return allNFTs.sorted { $0.name < $1.name }
        case .price:
            return allNFTs.sorted { $0.price < $1.price }
        case .rating:
            return allNFTs.sorted { $0.rating > $1.rating }
        }
    }
    
    func toggleLike(for nft: NFT) {
        if let index = likedNFTs.firstIndex(of: nft) {
            likedNFTs.remove(at: index)
        } else {
            likedNFTs.append(nft)
        }
    }
    
    func isLiked(_ nft: NFT) -> Bool{
        likedNFTs.contains(where: { $0.id == nft.id})
    }
    
    var likeCount: Int {
        likedNFTs.count
    }
}
