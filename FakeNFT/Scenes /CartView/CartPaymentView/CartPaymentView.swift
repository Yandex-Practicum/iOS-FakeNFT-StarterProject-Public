//
//  CartBuyButtonView.swift
//  FakeNFT
//
//  Created by Max on 28.05.2025.
//

import SwiftUI

struct CartPaymentView: View {
    
    @EnvironmentObject var viewModel: CartViewViewModel
    let onPaymentTap: () -> Void
    
    var body: some View {
        HStack {
            amount
            button
        }
        .padding()
        .frame(height: 76)
        .background(Color.lightGrayDay)
        .cornerRadius(16)
    }
    
    private var amount: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.nftCount) NFT")
                .font(.regular15)
            Text("\(viewModel.totalAmount.formatted()) ETH")
                .font(.bold17)
                .foregroundStyle(Color.yaGreenUniversal)
        }
        .padding(.trailing, 16)
    }
    
    private var button: some View {
        ButtonView(action: onPaymentTap, textColor: .whiteDay, buttonColor: .blackDay, text: "Оплатить", font: .bold17, cornerRadius: 16, buttonHieght: 44)
    }
}

#Preview {
    CartPaymentView(onPaymentTap: {})
        .environmentObject(CartViewViewModel())
}
