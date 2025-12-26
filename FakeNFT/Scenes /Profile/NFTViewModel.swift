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
    @AppStorage("selectedSortOption") private var storedSortOption: String = SortOption.name.rawValue

    @Published var isShowingFilterSheet: Bool = false
    @Published var favoritesNfts: [Nft] = []
    @Published var nfts: [Nft] = []
    
    private let likesService: LikesService
    private let nftService: NftService

    
    init(likesService: LikesService, nftService: NftService) {
        self.likesService = likesService
        self.nftService = nftService
    }
  
  

    
    var selectedSortOption: SortOption {
        get{ SortOption(rawValue: storedSortOption) ?? .name}
        set { storedSortOption = newValue.rawValue }
    }
    
    var sortedNFTs: [Nft] {
        switch selectedSortOption {
        case .name:
            return nfts.sorted { $0.name < $1.name }
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        }
    }
    
    func toggleLike(for nft: Nft) {
        if let index = favoritesNfts.firstIndex(of: nft) {
            favoritesNfts.remove(at: index)
        } else {
            favoritesNfts.append(nft)
        }
    }
    
    func isLiked(_ nft: Nft) -> Bool{
        favoritesNfts.contains(where: { $0.id == nft.id})
    }
    
    var likeCount: Int {
        favoritesNfts.count
    }
}
