//
//  CurrencyCellView.swift
//  FakeNFT
//
//  Created by Max on 29.05.2025.
//

import SwiftUI

struct CurrencyCellView: View {
    
    let currency: Currency
    @ObservedObject var viewModel: CurrencyViewModel
    
    private var isSelected: Bool {
        viewModel.selectedCurrency?.id == currency.id
    }
    
    var body: some View {
        Button(action: {
            viewModel.selectCurrency(currency)
        }) {
            HStack {
                currencyImage
                currencyName
            }
            .frame(height: 46)
            .frame(maxWidth: 210, alignment: .leading)
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blackDay : Color.clear, lineWidth: 1))
            .background(Color.lightGrayDay)
            .cornerRadius(12)
        }
    }
    
    private var currencyImage: some View {
        AsyncImage(url: URL(string: currency.image)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                    ProgressView()
                }
                .frame(width: 32, height: 32)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding(.leading, 12)
                    .clipped()
                    .cornerRadius(12)
                
            case .failure:
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.gray)
                }
                .frame(width: 32, height: 32)
                
            @unknown default:
                EmptyView()
            }
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
    CurrencyCellView(currency: Currency.mock, viewModel: CurrencyViewModel())
        .background(Color.pink.opacity(0.7))
}
