//
//  UserCollectionView.swift
//  FakeNFT
//
//  Created by Anastasia on 04.06.2025.
//

import SwiftUI

struct UserCollectionView: View {
    
    // TODO: 3/3 Statistics
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
            .modifier(NavigationBarStyle(
                title: "Коллекция NFT",
                backButtonHidden: false,
                filterButtonHidden: true,
                filterButtonTapHandler: { }
            ))
            .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        UserCollectionView()
    }
}
