//
//  NFTCollection.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import SwiftUI

struct UserNFTCollection: View {
    
    var likeTapHandler: (Int) -> Void
    var cartTapHandler: (Int) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0..<7) { index in // TODO: ForEach
                    CollectionRow(
                        index: index,
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
    UserNFTCollection(likeTapHandler: {_ in }, cartTapHandler: {_ in })
}
