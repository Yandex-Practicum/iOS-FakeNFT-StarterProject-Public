//
//  ButtonView.swift
//  FakeNFT
//
//  Created by Max on 28.05.2025.
//

import SwiftUI

struct ButtonView: View {
    let action: () -> Void
    let textColor: Color
    let buttonColor: Color
    let text: String
    let font: Font
    let cornerRadius: CGFloat
    let buttonHieght: CGFloat
    
    var body: some View {
        
        Button(action: action) {
            Text(text)
                .font(font)
                .foregroundStyle(textColor)
        }
        .frame(maxWidth: .infinity)
        .frame(height: buttonHieght)
        .background(buttonColor)
        .clipShape(.rect(cornerRadius: cornerRadius))
    }
}

#Preview {
    ButtonView(action: {}, textColor: .whiteDay, buttonColor: .blackDay, text: "Оплатить", font: .bold17, cornerRadius: 16, buttonHieght: 40)
}
