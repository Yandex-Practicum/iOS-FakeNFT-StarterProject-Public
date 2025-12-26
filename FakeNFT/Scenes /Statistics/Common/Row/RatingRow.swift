//
//  RatingRow.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct RatingRow: View {
    
    // MARK: - Properties
        
    let user: User
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: StatisticsConstants.anchorSmall) {
            Text(user.rating)
                .font(.regular15)
                .foregroundStyle(Color.blackDay)
                .frame(width: StatisticsConstants.ratingLabelWidth)
            RoundedRectangle(cornerRadius: StatisticsConstants.cornerRadiusSmall)
                .fill(Color.lightGrayDay)
                .frame(height: StatisticsConstants.ratingRowHeight)
                .overlay {
                    userInfo()
                }
        }
    }
    
    private func userInfo() -> some View {
        HStack(spacing: .zero) {
            UserAvatar(
                url: user.avatar,
                size: StatisticsConstants.avatarSizeSmall
            )
                .padding(.leading)
            Group {
                Text(user.name)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, StatisticsConstants.anchorSmall)
                Text("\(user.nfts.count)")
                    .padding(.horizontal)
            }
            .font(.bold22)
            .foregroundStyle(Color.blackDay)
        }
    }
}

#Preview {
    let user = User(
        id: "1",
        name: "Joaquin Phoenix",
        avatar: "",
        description: "",
        website: "",
        nfts: ["1", "2", "3"],
        rating: "1"
    )
    RatingRow(user: user)
}
