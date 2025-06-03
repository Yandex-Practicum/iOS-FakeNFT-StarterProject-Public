//
//  RatingView.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct RatingView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = RatingViewModel()
    
    // MARK: - Content
    
    var body: some View {
        NavigationStack {
            content
                .onAppear {
                    viewModel.loadUsers()
                }
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
                    viewModel.isShowingFilterSheet = true
                }
            ))
            .confirmationDialog(
                "Сортировка",
                isPresented: $viewModel.isShowingFilterSheet,
                titleVisibility: .visible
            ) {
                Button("По имени") {
                    viewModel.filterUsers(by: .name)
                }
                Button("По рейтингу") {
                    viewModel.filterUsers(by: .rating)
                }
            }
    }
    
    private var ratingList: some View {
        VStack(spacing: .zero) {
            RatingList(isLoading: false) {
                ForEach(viewModel.filteredUsers) { user in
                    RatingRow(user: user)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, StatisticsConstants.topAnchorSmall)
    }
}

#Preview {
    RatingView()
}
