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
            Text("user.description")
                .font(.footnote)
                .foregroundStyle(Color.blackDay)
                .padding(.top, StatisticsConstants.topAnchorSmall)
            Spacer()
        }
        .padding(.top, StatisticsConstants.topAnchorSmall)
        .padding(.horizontal)
    }
    
    private var userInfo: some View {
        HStack(spacing: .zero) {
            UserAvatar(
                url: "user.avatar",
                size: StatisticsConstants.avatarSizeLarge
            )
            Text("user.name")
                .font(.bold22)
                .foregroundStyle(Color.blackDay)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationView {
        UserCardView(isTabBarHidden: .constant(true))
    }
}
