//
//  UserNft.swift
//  FakeNFT
//
//  Created by Mac on 17.06.2025.
//

import SwiftUI
import Combine

struct UserNFT: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @State private var showSortSheet = false
    
    
    var body: some View {
        NavigationView{
            if viewModel.nfts.isEmpty{
                Text("У вас еще нет NFT")
                    .font(.custom("SFProText-Bold", size: 17))
                
            } else {
                ScrollView{
                    LazyVStack(spacing: 12){
                        ForEach(viewModel.nfts) { nft in
                            NFTCardView(nft: nft)
                            
                        }
                        
                    }
                }
                
                

            }
        }
        .navigationBarBackButtonHidden(true)
        .modifier(NavigationBarStyle(
                            title: "Мои NFT",
                            backButtonHidden: false,
                            filterButtonHidden: false,
                            filterButtonTapHandler: {
                                showSortSheet = true
                                
                            }
                        ))
        .confirmationDialog("Сортировка", isPresented: $showSortSheet, titleVisibility: .visible) {
            ForEach(ProfileViewModel.SortOption.allCases) { option in
                Button(option.rawValue) {
                    
                    switch option {
                    case .name:
                        viewModel.nfts.sort { $0.name < $1.name }
                    case .price:
                        viewModel.nfts.sort { $0.price > $1.price }
                    case .rating:
                        viewModel.nfts.sort { $0.rating > $1.rating }
                    }
                    
                }
            }
            
            Button("Закрыть", role: .cancel) {}
        }
    }
}

#Preview {
     UserNFT()
}
