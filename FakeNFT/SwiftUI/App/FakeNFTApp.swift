//
//  FakeNFTApp.swift
//  FakeNFT
//
//  Created by Василий Ханин on 12.09.2025.
//


import SwiftUI

@main
struct FakeNFTApp: App {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "blackAndWhite")
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(initialTab: .catalog)
                .tint(Color(.blueUniversal))
        }
    }
}
