//
//  UserCardView.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct UserCardView: View {
    
    @Binding var isTabBarHidden: Bool
    
    // TODO: 2/3 Statistics
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
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
}

#Preview {
    NavigationView {
        UserCardView(isTabBarHidden: .constant(true))
    }
}
