//
//  RatingView.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct RatingView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: RatingViewModel
    @Binding var isTabBarHidden: Bool
    
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
            .alert(isPresented: $viewModel.isShowingErrorAlert) {
                Alert(
                    title: Text("Не удалось получить данные"),
                    primaryButton: .default(
                        Text("Отмена")
                    ),
                    secondaryButton: .default(
                        Text("Повторить"),
                        action: {
                            viewModel.loadUsers()
                        }
                    )
                )
            }
    }
    
    private var ratingList: some View {
        VStack(spacing: .zero) {
            RatingList(isLoading: viewModel.isLoading) {
                ForEach(viewModel.filteredUsers) { user in
                    NavigationLink(destination: UserCardView(
                        user: user,
                        isTabBarHidden: $isTabBarHidden
                    )) {
                        RatingRow(user: user)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, StatisticsConstants.topAnchorSmall)
    }
}

#Preview {
    let services = ServicesAssembly()
    RatingView(
        viewModel: RatingViewModel(usersService: services.usersService),
        isTabBarHidden: .constant(true)
    )
}
