//
//  CartView.swift
//  FakeNFT
//
//  Created by Max on 26.05.2025.
//

import SwiftUI

struct CartView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var viewModel: CartViewViewModel
    @Binding var isTabBarHidden: Bool
    @Binding var selectedTab: Tab
    @State private var showPayment = false
    @State private var showSortDialog = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Group {
                contentView
            }
            .blur(radius: viewModel.showDeleteConfirmation ? 12 : 0)
            .task {
                await viewModel.loadCart()
                if viewModel.isEmpty {
                    showPayment = false
                }
            }
            .overlay { if viewModel.isDeleting {
                LoadingView()
            }
                deleteConfirmationOverlay
            }
            .animation(.easeInOut(duration: 0.4), value: viewModel.showDeleteConfirmation)
            .modifier(
                NavigationBarStyle(
                    title: "",
                    backButtonHidden: true,
                    filterButtonHidden: viewModel.isEmpty,
                    filterButtonTapHandler: {
                        showSortDialog = true
                    }
                )
            )
            .toolbar(
                viewModel.showDeleteConfirmation ? .hidden : .visible,
                for: .navigationBar
            )
            .navigationDestination(isPresented: $showPayment) {
                ChoosePaymentView(
                    isTabBarHidden: $isTabBarHidden,
                    selectedTab: $selectedTab, showPayment: $showPayment
                )
            }
            .frame(maxHeight: .infinity)
        }
        .confirmationDialog(
            "Сортировка",
            isPresented: $showSortDialog,
            titleVisibility: .visible
        ) {
            sortDialogActions
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            LoadingView()
            
        case .empty:
            emptyStateView
            
        case .loaded:
            loadedStateView
            
        case .error(let errorMessage):
            errorStateView(errorMessage)
        }
    }
    
    private var emptyStateView: some View {
        Text("Корзина пуста")
            .font(.bold17)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                showPayment = false
            }
    }
    
    private var loadedStateView: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.cartItems, id: \.id) { item in
                    CartCellView(item: item) {
                        viewModel.nftToDelete = item
                        viewModel.showDeleteConfirmation = true
                    }
                }
                Spacer()
            }
            
            CartBottomPanel(onPaymentTap: {
                showPayment = true
                isTabBarHidden = true
            })
        }
    }
    
    private func errorStateView(_ errorMessage: String) -> some View {
        VStack {
            Text("Ошибка")
                .font(.bold17)
            
            Text(errorMessage)
                .font(.regular13)
                .multilineTextAlignment(.center)
            
            Button("Повторить") {
                Task {
                    await viewModel.loadCart()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Overlays
    
    @ViewBuilder
    private var deleteConfirmationOverlay: some View {
        if viewModel.showDeleteConfirmation, let nft = viewModel.nftToDelete {
            ZStack {
                Color.white
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissDeleteConfirmation()
                    }
                
                DeleteConfirmationView(
                    nft: nft,
                    onDelete: {
                        viewModel.removeFromCart(nft)
                        dismissDeleteConfirmation()
                    },
                    onCancel: {
                        dismissDeleteConfirmation()
                    }
                )
            }
        }
    }
    
    // MARK: - Dialog Actions
    
    @ViewBuilder
    private var sortDialogActions: some View {
        ForEach(CartSortType.allCases, id: \.self) { sortType in
            Button(sortType.rawValue) {
                viewModel.sortItems(by: sortType)
            }
        }
        Button("Закрыть", role: .cancel) { }
    }
    
    // MARK: - Helper Methods
    
    private func dismissDeleteConfirmation() {
        viewModel.showDeleteConfirmation = false
        viewModel.nftToDelete = nil
    }
}

// MARK: - Preview

#Preview {
    CartView(isTabBarHidden: .constant(false), selectedTab: .constant(.cart))
        .environmentObject(CartViewViewModel())
}
