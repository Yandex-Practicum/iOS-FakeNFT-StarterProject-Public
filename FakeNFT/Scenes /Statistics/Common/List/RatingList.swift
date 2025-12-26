//
//  RatingList.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct RatingList<Content: View>: View {
    
    // MARK: - Properties
    
    let isLoading: Bool
    @ViewBuilder var content: Content
    
    // MARK: - Content
    
    var body: some View {
       if isLoading {
           LoadingView()
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: StatisticsConstants.anchorSmall) {
                    content
                }
            }
        }
    }
}

#Preview {
    RatingList(isLoading: true) {}
}
