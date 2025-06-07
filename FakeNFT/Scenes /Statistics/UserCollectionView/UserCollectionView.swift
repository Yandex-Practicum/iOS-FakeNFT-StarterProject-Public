//
//  UserCollectionView.swift
//  FakeNFT
//
//  Created by Anastasia on 04.06.2025.
//

import SwiftUI

struct UserCollectionView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: UserCollectionViewModel
    
    // MARK: - Initializers
    
    init(nftIds: [String], service: ServicesAssembly) {
        self.viewModel = UserCollectionViewModel(nftIds: nftIds, nftInfoService: service.nftInfoService)
    }
    
    // MARK: - Content
    
    var body: some View {
        content
            .modifier(NavigationBarStyle(
                title: "Коллекция NFT",
                backButtonHidden: false,
                filterButtonHidden: true,
                filterButtonTapHandler: {}
            ))
            .onAppear {
                viewModel.loadData()
            }
            .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - View
    
    private var content: some View {
        ZStack {
            UserNFTCollection(
                nftInfo: viewModel.nftInfo,
                likeTapHandler: { nft in
                    print("like tapped \(nft.id)")
                },
                cartTapHandler: { nft in
                    print("cart tapped \(nft.id)")
                }
            )
            .padding(.top, StatisticsConstants.topAnchorSmall)
             LoadingView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
    }
}

#Preview {
    NavigationStack {
        UserCollectionView(nftIds: [""], service: ServicesAssembly())
    }
}
