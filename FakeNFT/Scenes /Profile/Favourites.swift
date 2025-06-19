//
//  Favourites.swift
//  FakeNFT
//
//  Created by Mac on 17.06.2025.
//

import SwiftUI



struct Favourites: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        NavigationView {
            content
                .modifier(NavigationBarStyle(
                    title: "Избранные NFT",
                    backButtonHidden: false,
                    filterButtonHidden: true,
                    filterButtonTapHandler: {}
                ))
        }

            
    }
    
    var content: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: .zero) {
                nft
                nft
                nft
                nft
                nft
                nft
            }.padding(13)
            
        }
    }
    var nft: some View{
        FavouriteNft(name: "Lilo", nft: NftInfo(
            id: "",
            name: "",
            images: [""],
            rating: 4,
            price: 1.79
        ),
        userLikes: UserLikes(likes: []),
        userOrders: UserOrders(nfts: []),
        likeTapHandler: {_ in },
        cartTapHandler: {_ in})
    }
}

#Preview {
    Favourites()
}
