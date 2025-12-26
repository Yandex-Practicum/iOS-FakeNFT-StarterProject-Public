//
//  FakeNftApp.swift
//  FakeNFT
//
//  Created by Max on 24.05.2025.
//

import SwiftUI

@main
struct FakeNftApp: App {
    
    @StateObject var service = ServicesAssembly()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(service)
        }
    }
}

