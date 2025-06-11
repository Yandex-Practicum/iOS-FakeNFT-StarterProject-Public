//
//  ChoosePaymentView.swift
//  FakeNFT
//
//  Created by Max on 29.05.2025.
//

import SwiftUI

struct ChoosePaymentView: View {
    
    @Binding var isTabBarHidden: Bool
    @State private var showSuccessPayment = false
    @StateObject private var viewModel = CurrencyViewModel()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 7), count: 2)
    
    var body: some View {
        Group {
            switch viewModel.state {
                
            case.loading:
                LoadingView()
                
            case.empty:
                Text("Валюты не найдены")
                    .font(.bold17)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case.loaded(let currencies):
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns,  spacing: 7) {
                            ForEach(currencies) { currency in
                                CurrencyCellView(currency: currency, viewModel: viewModel)
                            }
                        }
                    }
                    .padding()
                    
                    PaymentBottomPanel(viewModel: viewModel, onPaymentTap: {
                        showSuccessPayment = true
                    }
                    )
                }
                
            case .error(let errorMessage):
                Text("\(errorMessage)")
                
            }
        }
        .modifier(NavigationBarStyle(
            title: "Выберете способ оплаты",
            backButtonHidden: false,
            filterButtonHidden: true,
            isTabBarHidden: $isTabBarHidden,
            filterButtonTapHandler: {}
        ))
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(.all, edges: .bottom)
        .task {
            await viewModel.loadCurrencies()
        }
        .navigationDestination(isPresented: $showSuccessPayment) {
            SuccessPaymentView()
        }
    }
    
}

#Preview {
    ChoosePaymentView(isTabBarHidden: .constant(true))
        .environmentObject(CartViewViewModel())
}
