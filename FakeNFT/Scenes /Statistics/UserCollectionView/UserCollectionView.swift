//
//  UserCollectionView.swift
//  FakeNFT
//
//  Created by Anastasia on 04.06.2025.
//

import SwiftUI

struct UserCollectionView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: UserCollectionViewModel
    
    // MARK: - Initializers
    
    init(nftIds: [String], service: ServicesAssembly) {
        self.viewModel = UserCollectionViewModel(nftIds: nftIds, service: service)
    }
    
    // MARK: - Content
    
    var body: some View {
        content
            .modifier(NavigationBarStyle(
                title: "Коллекция NFT",
                backButtonHidden: false,
                filterButtonHidden: true,
                filterButtonTapHandler: {}
            ))
            .onAppear {
                viewModel.loadData()
            }
            .alert(isPresented: $viewModel.isShowingErrorAlert) {
                Alert(
                    title: Text("Не удалось получить данные"),
                    primaryButton: .default(
                        Text("Отмена")
                    ),
                    secondaryButton: .default(
                        Text("Повторить"),
                        action: {
                            viewModel.loadData()
                        }
                    )
                )
            }
            .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - View
    
    private var content: some View {
        ZStack {
            UserNFTCollection(
                nftInfo: viewModel.nftInfo,
                userLikes: viewModel.userLikes,
                userOrders: viewModel.userOrders,
                likeTapHandler: { nft in
                    viewModel.updateLike(nftId: nft.id)
                },
                cartTapHandler: { nft in
                    viewModel.updateUserOrder(nftId: nft.id)
                }
            )
            .padding(.top, StatisticsConstants.topAnchorSmall)
            Text("Пусто")
                .font(.bold17)
                .opacity(viewModel.nftIds.isEmpty ? 1 : 0)
             LoadingView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
    }
}

#Preview {
    NavigationStack {
        UserCollectionView(nftIds: [""], service: ServicesAssembly())
    }
}
