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
    
    @Published var nfts: [NFT] = MockNFTData.nfts
    @Published var sortedNFTs: [NFT] = []
    @Published var isShowingFilterSheet: Bool = false
    
    @AppStorage("selectedSortOption") private var storedSortOption: String = SortOption.name.rawValue
    
    var selectedSortOption: SortOption {
         SortOption(rawValue: storedSortOption) ?? .name
    }
    
    init() {
        applySort(by: selectedSortOption)
    }

    func applySort(by option: SortOption) {
        switch option {
        case .name:
            sortedNFTs = nfts.sorted { $0.name < $1.name }
        case .price:
            sortedNFTs = nfts.sorted { $0.price < $1.price }
        case .rating:
            sortedNFTs = nfts.sorted { $0.rating > $1.rating }
        }
    }
}
