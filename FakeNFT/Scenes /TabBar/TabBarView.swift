//
//  TabBarView.swift
//  FakeNFT
//
//  Created by Anastasia on 25.05.2025.
//

import SwiftUI

struct TabBarView: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases.prefix(4), id: \.self) { tab in
                Button {
                    self.selectedTab = tab
                } label: {
                    tabItemView(for: tab)
                }
                .tint(selectedTab == tab ? .yaBlueUniversal : .blackDay)
            }
        }
        .padding(.horizontal)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func tabItemView(for tab: Tab) -> some View {
        VStack {
            Image("\(tab.imageName)")
                .resizable()
                .frame(width: 30, height: 30)
            Text(tab.title)
                .font(.medium10)
        }
        .frame(maxWidth: .infinity)
    }
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.shadowColor = .clear
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
}

#Preview {
    Spacer()
    TabBarView(selectedTab: .constant(.profile))
}
