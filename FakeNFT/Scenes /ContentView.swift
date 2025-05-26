//
//  ContentView.swift
//  FakeNFT
//
//  Created by Max on 24.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = Tab.profile
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                TabView(selection: $selectedTab) {
                    Text("Profile")
                        .tag(Tab.profile)
                    
                    Text("Catalog")
                        .tag(Tab.catalog)
                    
                    Text("Cart")
                        .tag(Tab.cart)
                    
                    Text("Statistics")
                        .tag(Tab.statistics)
                }
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
