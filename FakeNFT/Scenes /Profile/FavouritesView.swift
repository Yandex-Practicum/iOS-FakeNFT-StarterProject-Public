//
//  Favourites.swift
//  FakeNFT
//
//  Created by Mac on 17.06.2025.
//

import SwiftUI


struct FavouritesView: View {
    
    @EnvironmentObject var viewModel: NFTViewModel

    
    var body: some View {
        NavigationView {
            VStack{
                if viewModel.likedNFTs.isEmpty {
                    Text("Нет избранных NFT")
                        .font(.headline)
                        .padding()
                    
                } else {
                    ScrollView{
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.likedNFTs) { nft in
                                NFTCardView(nft:nft)
                                
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
    FavouritesView()
}
