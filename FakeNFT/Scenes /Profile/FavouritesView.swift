//
//  Favourites.swift
//  FakeNFT
//
//  Created by Mac on 17.06.2025.
//

import SwiftUI


struct FavouritesView: View {
    @EnvironmentObject var viewModel: ProfileViewModel

    
    var body: some View {
        NavigationView {
            VStack{
                if viewModel.favoritesNfts.isEmpty {
                    Text("Нет избранных NFT")
                        .font(.custom("SFProText-Bold", size: 17))
                        .padding()
                    
                } else {
                    ScrollView{
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favoritesNfts) { nft in
                                NFTCardView(nft: nft)
                                
                            }
                        }
                        
                    }
                }
            }
                .modifier(NavigationBarStyle(
                    title: "Избранные NFT",
                    backButtonHidden: false,
                    filterButtonHidden: true,
                    filterButtonTapHandler: {}
                ))
        }
        .navigationBarBackButtonHidden(true)
    }
    

}

#Preview {
//    FavouritesView()
}
