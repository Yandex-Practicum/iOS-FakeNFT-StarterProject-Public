//
//  CartView.swift
//  FakeNFT
//
//  Created by Max on 26.05.2025.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var viewModel: CartViewViewModel
    @Binding var isTabBarHidden: Bool
    @State private var showPayment = false
    @State private var showSortDialog = false
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    LoadingView()
                    
                case .empty:
                    Text("Корзина пуста")
                        .font(.bold17)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .loaded:
                    VStack {
                        ScrollView {
                            ForEach(viewModel.cartItems, id: \.id) { item in
                                CartCellView(item: item) {
                                    viewModel.removeFromCart(item)
                                }
                            }
                            Spacer()
                        }
                        CartPaymentView(onPaymentTap: {
                            showPayment = true
                            isTabBarHidden = true
                        })
                    }
                case .error(let errorMessage):
                    VStack {
                        Text("Ошибка")
                            .font(.bold17)
                        Text(errorMessage)
                            .font(.regular13)
                            .multilineTextAlignment(.center)
                        Button("Повторить") {
                            Task { await viewModel.loadCart() }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .task {
                await viewModel.loadCart()
            }
            .navigationDestination(isPresented: $showPayment) {
                ChoosePaymentView(isTabBarHidden: $isTabBarHidden)
            }
            .frame(maxHeight: .infinity)
            .modifier(NavigationBarStyle(title: "", backButtonHidden: true, filterButtonHidden: false, filterButtonTapHandler: {
                showSortDialog = true
            }))
        }
        .confirmationDialog("Сортировка", isPresented: $showSortDialog,titleVisibility: .visible) {
            ForEach(CartSortType.allCases, id: \.self) { sortType in
                Button(sortType.rawValue) {
                    viewModel.sortItems(by: sortType)
                }
            }
            Button("Закрыть", role: .cancel) { }
        }
    }
}




#Preview {
    CartView(isTabBarHidden: .constant(false))
        .environmentObject(CartViewViewModel())
}
