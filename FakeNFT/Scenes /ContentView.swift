//
//  ContentView.swift
//  FakeNFT
//
//  Created by Max on 24.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var service: ServicesAssembly
    @StateObject private var cartViewModel = CartViewViewModel()
    @State private var isTabBarHidden = false
    @State private var selectedTab = Tab.profile
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                Text("Profile")
                    .tag(Tab.profile)
                
                Text("Catalog")
                    .tag(Tab.catalog)
                
                CartView(isTabBarHidden: $isTabBarHidden, selectedTab: $selectedTab)
                    .tag(Tab.cart)
                    .environmentObject(cartViewModel)
                
                RatingView(
                    viewModel: RatingViewModel(usersService: service.usersService),
                    isTabBarHidden: $isTabBarHidden
                )
                    .tag(Tab.statistics)
            }
           
            if !isTabBarHidden {
                TabBarView(selectedTab: $selectedTab)
                    .blur(radius: cartViewModel.showDeleteConfirmation ? 12 : 0)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ServicesAssembly())

}
