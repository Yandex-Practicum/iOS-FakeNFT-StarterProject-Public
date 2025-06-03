//
//  RatingView.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct RatingView: View {
    
    // MARK: - Properties
    
    
    // MARK: - Content
    
    var body: some View {
        NavigationStack {
            content
        }
    }
    
    // MARK: - View
    
    private var content: some View {
        ratingList
            .modifier(NavigationBarStyle(
                title: nil,
                backButtonHidden: true,
                filterButtonHidden: false,
                filterButtonTapHandler: {
                    
                }
            ))
    }
    
    private var ratingList: some View {
        VStack(spacing: .zero) {
            
        }
        .padding(.horizontal)
        .padding(.top, StatisticsConstants.topAnchorSmall)
    }
}

#Preview {
    RatingView()
}
