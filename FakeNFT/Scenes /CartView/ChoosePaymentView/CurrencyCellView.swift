//
//  CurrencyCellView.swift
//  FakeNFT
//
//  Created by Max on 29.05.2025.
//

import SwiftUI

struct CurrencyCellView: View {
    
    let currency: Currency
    //let onSelect: () -> Void
    
    var body: some View {
        HStack {
            currencyImage
            currencyName
        }
        .frame(height: 46)
        .frame(maxWidth: 210, alignment: .leading)
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(Color.blackDay, lineWidth: 1))
        .background(Color.lightGrayDay)
        .cornerRadius(12)
    }
    
    private var currencyImage: some View {
        AsyncImage(url: URL(string: currency.image)) { image in
            image
                .image?.resizable()
                .frame(width: 32, height: 32)
                .padding(.leading,12)
        }
    }
    private var currencyName: some View {
        VStack(alignment: .leading) {
            Text("\(currency.title)")
                .font(.regular13)
                .foregroundStyle(Color.blackDay)
            Text("\(currency.name)")
                .font(.regular13)
                .foregroundStyle(Color.yaGreenUniversal)
        }
    }
}
#Preview {
    CurrencyCellView(currency: Currency.mock)
        .background(Color.pink.opacity(0.7))
        .environmentObject(CartViewViewModel())
}
