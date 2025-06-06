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
                
                CartView(isTabBarHidden: $isTabBarHidden)
                    .tag(Tab.cart)
                    .environmentObject(cartViewModel)
                
                Text("Statistics")
                    .tag(Tab.statistics)
            }
            if !isTabBarHidden {
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ServicesAssembly())

}
