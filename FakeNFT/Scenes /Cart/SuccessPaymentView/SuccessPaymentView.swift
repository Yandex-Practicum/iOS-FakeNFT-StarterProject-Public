//
//  SuccessPaymentView.swift
//  FakeNFT
//
//  Created by Max on 11.06.2025.
//

import SwiftUI

struct SuccessPaymentView: View {
    
    @Binding var selectedTab: Tab
    @Binding var isTabBarHidden: Bool
    @Binding var showPayment: Bool
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartViewModel: CartViewViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Image("successPayment")
                .resizable()
                .frame(width: 278, height: 278)
            Text("Успех! Оплата прошла, поздравляем с покупкой!")
                .font(.bold22)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            ButtonView(action: {returnToCatalog()}, textColor: .whiteDay, buttonColor: .blackDay, text: "Вернуться в каталог", font: .bold17, cornerRadius: 16, buttonHieght: 60)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    private func returnToCatalog() {
        Task {
            await cartViewModel.clearCartOnServerOnly()
        }
        showPayment = false
        selectedTab = .catalog
        isTabBarHidden = false
        dismiss()
    }
}


#Preview {
    SuccessPaymentView(
        selectedTab: .constant(.cart),
        isTabBarHidden: .constant(true), showPayment: .constant(true)
    )
}
