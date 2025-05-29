//
//  NavigationBarStyle.swift
//  FakeNFT
//
//  Created by Anastasia on 25.05.2025.
//

import SwiftUI

struct NavigationBarStyle: ViewModifier {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    
    let title: String?
    let backButtonHidden: Bool
    let filterButtonHidden: Bool
    let isTabBarHidden: Binding<Bool>?
    var filterButtonTapHandler: () -> Void?
    
    // MARK: - Initializers
    
    init(title: String?,
         backButtonHidden: Bool,
         filterButtonHidden: Bool,
         isTabBarHidden: Binding<Bool>? = nil,
         filterButtonTapHandler: @escaping () -> Void?
    ) {
        self.title = title
        self.backButtonHidden = backButtonHidden
        self.filterButtonHidden = filterButtonHidden
        self.isTabBarHidden = isTabBarHidden
        self.filterButtonTapHandler = filterButtonTapHandler
        setupNavigationBarAppearance()
    }
    
    // MARK: - Content
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                        .opacity(backButtonHidden ? 0 : 1)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    filterButton
                        .opacity(filterButtonHidden ? 0 : 1)
                }
            }
    }
    
    // MARK: - View
    
    private var backButton: some View {
        Button {
            isTabBarHidden?.wrappedValue = false
            dismiss()
        } label: {
            Image("backButton")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .tint(.blackDay)
        }
    }
    
    private var filterButton: some View {
        Button {
            filterButtonTapHandler()
        } label: {
            Image("filterButton")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .tint(.blackDay)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBarAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
    }
}

#Preview {
    NavigationView {
        Text("Пример использования NavigationBarStyle с разными настройками")
            .modifier(NavigationBarStyle(
                title: "Мои NFT",
                backButtonHidden: false,
                filterButtonHidden: false,
                filterButtonTapHandler: {}
            ))
    }
    
    NavigationView {
        Text("Пример использования NavigationBarStyle с разными настройками")
            .modifier(NavigationBarStyle(
                title: "Коллекция NFT",
                backButtonHidden: false,
                filterButtonHidden: true,
                filterButtonTapHandler: {}
            ))
    }
    
    NavigationView {
        Text("Пример использования NavigationBarStyle с разными настройками")
            .modifier(NavigationBarStyle(
                title: nil,
                backButtonHidden: false,
                filterButtonHidden: true,
                filterButtonTapHandler: {}
            ))
    }
}
