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
    
    var body: some View {
        NavigationStack {
            if viewModel.cartItems.isEmpty {
                Text("Корзина пуста")
                    .font(.bold17)
            } else {
                VStack {
                   ScrollView {
                        ForEach(viewModel.cartItems, id: \.id) { item in
                            CartCellView(item: item)
                        }
                        
                        
                        Spacer()
                        
                    }
                    CartPaymentView(onPaymentTap: {
                        showPayment = true
                        isTabBarHidden = true
                    })
                }
                .navigationDestination(isPresented: $showPayment) {
                    ChoosePaymentView(isTabBarHidden: $isTabBarHidden)
                }
                .frame(maxHeight: .infinity)
                .modifier(NavigationBarStyle(title: "", backButtonHidden: true, filterButtonHidden: false, filterButtonTapHandler: {}))
            }
        }
    }
}


#Preview {
    CartView(isTabBarHidden: .constant(false))
        .environmentObject(CartViewViewModel())
}
