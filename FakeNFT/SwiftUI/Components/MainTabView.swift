//
//  MainTabView.swift
//  FakeNFT
//
//  Created by Василий Ханин on 12.09.2025.
//


import SwiftUI

enum AppTab: Hashable {
    case basket,
         catalog,
         profile,
         statistics
}

struct MainTabView: View {
    @State private var selectedTab: AppTab
    
    init(initialTab: AppTab = .catalog) {
        _selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Profile
            Text("Profile Screen")
                .tabItem {
                    VStack(spacing: 1) {
                        Image(selectedTab == .profile ? "ActiveProfile" : "NoActiveProfile")
                            .renderingMode(.original)
                        Text("tab_profile")
                            .font(.appMedium10)
                    }
                }
                .tag(AppTab.profile)
            
            // Catalog
            Text("Catalog Screen")
                .tabItem {
                    VStack(spacing: 1) {
                        Image(selectedTab == .catalog ? "ActiveCatalog" : "NoActiveCatalog")
                            .renderingMode(.original)
                        Text("tab_catalog")
                            .font(.appMedium10)
                    }
                }
                .tag(AppTab.catalog)
            
            // Basket
            Text("Basket Screen")
                .tabItem {
                    VStack(spacing: 1) {
                        Image(selectedTab == .basket ? "ActiveBasket" : "NoActiveBasket")
                            .renderingMode(.original)
                        Text("tab_basket")
                            .font(.appMedium10)
                    }
                }
                .tag(AppTab.basket)
            
            // Statistics
            Text("Statistics Screen")
                .tabItem {
                    VStack(spacing: 1) {
                        Image(selectedTab == .statistics ? "ActiveStatistics" : "NoActiveStatistics")
                            .renderingMode(.original)
                        Text("tab_statistics")
                            .font(.appMedium10)
                    }
                }
                .tag(AppTab.statistics)
        }
    }
}

#Preview { MainTabView(initialTab: .catalog) }
