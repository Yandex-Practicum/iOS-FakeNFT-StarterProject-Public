//
//  UserCardView.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct UserCardView: View {
    
    // MARK: - Properties
    
    @Binding var isTabBarHidden: Bool
    @ObservedObject var viewModel: UserCardViewModel
    @EnvironmentObject var service: ServicesAssembly
    
    // MARK: - Initializers
    
    init(user: User, isTabBarHidden: Binding<Bool>) {
        self.viewModel = UserCardViewModel(user: user)
        self._isTabBarHidden = isTabBarHidden
    }
    
    // MARK: - Content
    
    var body: some View {
        content
            .modifier(NavigationBarStyle(
                title: nil,
                backButtonHidden: false,
                filterButtonHidden: true,
                isTabBarHidden: $isTabBarHidden,
                filterButtonTapHandler: { }
            ))
            .onAppear {
                isTabBarHidden = true
            }
    }
    
    // MARK: - View
    
    private var content: some View {
        VStack(alignment: .leading) {
            userInfo
            Text(viewModel.user.description ?? "")
                .font(.footnote)
                .foregroundStyle(Color.blackDay)
                .padding(.top, StatisticsConstants.topAnchorSmall)
            ShowWebViewButton(url: viewModel.user.website)
                .padding(.top, StatisticsConstants.topAnchorMedium)
            NavigationLink(
                destination: UserCollectionView(nftIds: viewModel.user.nfts, service: service)
            ) {
                ShowCollectionButton(nftsCount: viewModel.user.nfts.count)
                    .padding(.top, StatisticsConstants.topAnchorLarge)
            }
            Spacer()
        }
        .padding(.top, StatisticsConstants.topAnchorSmall)
        .padding(.horizontal)
    }
    
    private var userInfo: some View {
        HStack(spacing: .zero) {
            UserAvatar(
                url: viewModel.user.avatar,
                size: StatisticsConstants.avatarSizeLarge
            )
            Text(viewModel.user.name)
                .font(.bold22)
                .foregroundStyle(Color.blackDay)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    let userTest = User(id: "1",
                        name: "Joaquin Phoenix",
                        avatar: "",
                        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                        website: "",
                        nfts: ["1", "2", "3", "3", "3", "3"],
                        rating: "1"
    )
    NavigationView {
        UserCardView(
            user: userTest,
            isTabBarHidden: .constant(true)
            
        )
    }
}
