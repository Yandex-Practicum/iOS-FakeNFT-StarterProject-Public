//
//  NFTCollection.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import SwiftUI

struct UserNFTCollection: View {
    
    let nftInfo: [NftInfo]
    var likeTapHandler: (NftInfo) -> Void
    var cartTapHandler: (NftInfo) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(nftInfo, id: \.self) { nft in
                    CollectionRow(
                        nft: nft,
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
        likeTapHandler: {_ in },
        cartTapHandler: {_ in }
    )
}
