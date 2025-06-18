//
//  PaymentBottomPanel.swift
//  FakeNFT
//
//  Created by Max on 10.06.2025.
//

import SwiftUI

struct PaymentBottomPanel: View {
    
    @ObservedObject var viewModel: CurrencyViewModel
    let onPaymentTap: () -> Void
    
    private var isPaymentEnabled: Bool {
           viewModel.selectedCurrency != nil
       }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Совершая покупку вы соглашаетесь с условиями")
                .font(.regular13)
                .foregroundStyle(Color.blackDay)
            
            NavigationLink("Пользовательского соглашения", destination: 
                            WebView(url: URL(string: "https://practicum.yandex.ru") )
            )
                .font(.regular13)
                .foregroundStyle(Color.yaBlueUniversal)
            
            ButtonView(
                action: onPaymentTap,
                textColor: .whiteDay,
                buttonColor: .blackDay,
                text: "Оплатить",
                font: .bold17,
                cornerRadius: 16,
                buttonHieght: 60
            )
            .padding(.top, 10)
            .disabled(!isPaymentEnabled)
            
            Spacer()
        }
        .padding()
        .frame(height: 186)
        .background(Color.lightGrayDay)
        .cornerRadius(16)
    }
}

#Preview {
    PaymentBottomPanel(viewModel: CurrencyViewModel(), onPaymentTap: {})
}
