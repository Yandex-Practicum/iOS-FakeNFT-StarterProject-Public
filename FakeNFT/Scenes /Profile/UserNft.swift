//
//  UserNft.swift
//  FakeNFT
//
//  Created by Mac on 17.06.2025.
//

import SwiftUI

struct UserNft: View {
    
    var body: some View {
        NavigationView {
            content
                .modifier(NavigationBarStyle(
                    title: "Мои NFT",
                    backButtonHidden: false,
                    filterButtonHidden: false,
                    filterButtonTapHandler: {}
                ))
        }
        .navigationBarBackButtonHidden(true)
        
 
    }
    
    var content: some View{
        VStack(spacing: .zero){
            
            NftRow(
                        name: "Lilo", nft: NftInfo(
                            id: "",
                            name: "",
                            images: [""],
                            rating: 4,
                            price: 1.79
                        ),
                        userLikes: UserLikes(likes: []),
                        userOrders: UserOrders(nfts: []),
                        likeTapHandler: {_ in },
                        cartTapHandler: {_ in}
                    )
            NftRow(
                        name: "Lilo", nft: NftInfo(
                            id: "",
                            name: "",
                            images: [""],
                            rating: 4,
                            price: 1.79
                        ),
                        userLikes: UserLikes(likes: []),
                        userOrders: UserOrders(nfts: []),
                        likeTapHandler: {_ in },
                        cartTapHandler: {_ in}
                    )
            NftRow(
                        name: "Lilo", nft: NftInfo(
                            id: "",
                            name: "",
                            images: [""],
                            rating: 4,
                            price: 1.79
                        ),
                        userLikes: UserLikes(likes: []),
                        userOrders: UserOrders(nfts: []),
                        likeTapHandler: {_ in },
                        cartTapHandler: {_ in}
                    )


        }
        
        
        
        
        
        
    }
    
    
}

#Preview {
    UserNft()
}
