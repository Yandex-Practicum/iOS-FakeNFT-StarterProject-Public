//
//  ChoosePaymentView.swift
//  FakeNFT
//
//  Created by Max on 29.05.2025.
//

import SwiftUI

struct ChoosePaymentView: View {
    
    @Binding var isTabBarHidden: Bool
    @Binding var selectedTab: Tab
    @Binding var showPayment: Bool
    @State private var showSuccessPayment = false
    @State private var showPaymentAlert = false
    @StateObject private var viewModel = CurrencyViewModel()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 7), count: 2)
    
    var body: some View {
        Group {
            if viewModel.isProcessingPayment {
                LoadingView()
            } else {
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
                        
                        PaymentBottomPanel(viewModel: viewModel) {
                            Task {
                                await viewModel.processPayment()
                            }
                        }
                    }
                    
                case .error(let errorMessage):
                    Text("\(errorMessage)")
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
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(.all, edges: .bottom)
        .task {
            await viewModel.loadCurrencies()
        }
        .onChange(of: viewModel.paymentState) { state in
            switch state {
            case .success:
                showSuccessPayment = true
            case .failure:
                showPaymentAlert = true
            default:
                break
            }
        }
        .alert("Не удалось произвести оплату", isPresented: $showPaymentAlert) {
            Button("Повторить") {
                Task { await viewModel.processPayment() }
            }
            Button("Отмена", role: .cancel) {
                viewModel.resetPayment()
            }
        }
        .navigationDestination(isPresented: $showSuccessPayment) {
            SuccessPaymentView( selectedTab: $selectedTab,
                                isTabBarHidden: $isTabBarHidden, showPayment: $showPayment)
        }
    }
}

#Preview {
    ChoosePaymentView(isTabBarHidden: .constant(true), selectedTab: .constant(.cart), showPayment: .constant(true))
        .environmentObject(CartViewViewModel())
}
