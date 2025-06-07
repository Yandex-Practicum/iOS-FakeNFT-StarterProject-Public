//
//  NFTCollection.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import SwiftUI

struct UserNFTCollection: View {
    
    let nftInfo: [NftInfo]
    let userLikes: UserLikes
    var likeTapHandler: (NftInfo) -> Void
    var cartTapHandler: (NftInfo) -> Void
    
    let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(nftInfo, id: \.self) { nft in
                    CollectionRow(
                        nft: nft,
                        userLikes: userLikes,
                        likeTapHandler: likeTapHandler,
                        cartTapHandler: cartTapHandler
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    UserNFTCollection(
        nftInfo: [
            NftInfo(
                id: "",
                name: "",
                images: [""],
                rating: 1,
                price: 3.98
            )],
        userLikes: UserLikes(likes: []),
        likeTapHandler: {_ in },
        cartTapHandler: {_ in }
    )
}
