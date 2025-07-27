//
//  ContentView.swift
//  FakeNFT
//
//  Created by Max on 24.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var service: ServicesAssembly
    
    @State private var isTabBarHidden = false
    @State private var selectedTab = Tab.profile
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ProfileView(profileService: service.profileService, nftsService: service.nftService, likesService: service.likesService)
                    .tag(Tab.profile)
                
                Text("Catalog")
                    .tag(Tab.catalog)
                
                Text("Cart")
                    .tag(Tab.catalog)
                
                RatingView(
                    viewModel: RatingViewModel(usersService: service.usersService),
                    isTabBarHidden: $isTabBarHidden
                )
                    .tag(Tab.statistics)
            }
            if !isTabBarHidden {
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
//    ContentView()
//        .environmentObject(ServicesAssembly())
}
