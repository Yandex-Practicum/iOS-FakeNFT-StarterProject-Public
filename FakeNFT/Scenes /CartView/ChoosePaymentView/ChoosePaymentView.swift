//
//  ChoosePaymentView.swift
//  FakeNFT
//
//  Created by Max on 29.05.2025.
//

import SwiftUI

struct ChoosePaymentView: View {
    
    @Binding var isTabBarHidden: Bool
    @StateObject private var viewModel = CurrencyViewModel()
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.currencies.isEmpty {
                Text("Валюты не найдены")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.currencies) { currency in
                            CurrencyCellView(currency: currency)
                        }
                    }
                    .padding()
                }
            }
        }
        .modifier(NavigationBarStyle(
            title: "Выберете способ оплаты",
            backButtonHidden: false,
            filterButtonHidden: true,
            isTabBarHidden: $isTabBarHidden,
            filterButtonTapHandler: {}
        ))
        
        .task {
                        await viewModel.loadCurrencies()
                    }
                    .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
                        Button("OK") {
                            viewModel.errorMessage = nil
                        }
                    } message: {
                        Text(viewModel.errorMessage ?? "")
                    }
                }
            }
        
#Preview {
    ChoosePaymentView(isTabBarHidden: .constant(true))
        .environmentObject(CartViewViewModel())
}
