//
//  UserNft.swift
//  FakeNFT
//
//  Created by Mac on 17.06.2025.
//

import SwiftUI

struct UserNFT: View {
    @StateObject private var viewModel = NFTViewModel()
    @State private var showSortSheet = false
    var body: some View {
        NavigationView{
            if viewModel.sortedNFTs.isEmpty{
                Text("У вас еще нет NFT")
            } else {
                
                ScrollView{
                    LazyVStack(spacing: 12){
                        ForEach(viewModel.sortedNFTs) { nft in
                            NFTCardView(nft: nft)
                        }

                    }
                }
                
                .modifier(NavigationBarStyle(
                    title: "Мои NFT",
                    backButtonHidden: false,
                    filterButtonHidden: false,
                    filterButtonTapHandler: {
                        showSortSheet = true

                    }
                ))
            .confirmationDialog("Сортировка", isPresented: $showSortSheet, titleVisibility: .visible) {
                ForEach(NFTViewModel.SortOption.allCases) { option in
                    Button(option.rawValue) {
                        withAnimation {
                            viewModel.applySort(by: option)
                        }
                    }
                }
                
                Button("Закрыть", role: .cancel) {}
             }
            }
        }
        .navigationBarBackButtonHidden(true)
        
        
 
    }
        
    

}

#Preview {
    UserNFT()
}
