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
    
    init(nftIds: [String]) {
        self.viewModel = UserCollectionViewModel(nftIds: nftIds)
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
                // TODO: load data
            }
            .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - View
    
    private var content: some View {
        ZStack {
            UserNFTCollection(
                likeTapHandler: { index in
                    print("like tapped \(index)")
                },
                cartTapHandler: { index in
                    print("cart tapped \(index)")
                }
            )
            .padding(.top, StatisticsConstants.topAnchorSmall)
            // LoadingView() .opacity(isLoading ? 1 : 0)
        }
    }
    
}

#Preview {
    NavigationStack {
        UserCollectionView(nftIds: [""])
    }
}
