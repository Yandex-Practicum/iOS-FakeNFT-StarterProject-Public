//
//  SuccessPaymentView.swift
//  FakeNFT
//
//  Created by Max on 11.06.2025.
//

import SwiftUI

struct SuccessPaymentView: View {
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
            
            ButtonView(action: {}, textColor: .whiteDay, buttonColor: .blackDay, text: "Вернуться в каталог", font: .bold17, cornerRadius: 16, buttonHieght: 60)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SuccessPaymentView()
}
