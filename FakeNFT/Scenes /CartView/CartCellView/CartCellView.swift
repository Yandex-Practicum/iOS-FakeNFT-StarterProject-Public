//
//  CollectionCellView.swift
//  FakeNFT
//
//  Created by Max on 26.05.2025.
//

import SwiftUI

struct CartCellView: View {
    
    @EnvironmentObject var viewModel: CartViewViewModel
    let item: Nft
    
    var body: some View {
        HStack {
            nftImage
            VStack(alignment: .leading) {
                nftName
                starRating
                price
            }
            Spacer()
            
            Image("cartDelete")
        }
        .padding()
        .frame(maxHeight: 140)
    }
    
    private var nftName: some View {
        Text(item.name)
            .font(.bold17)
    }
    
    private var nftImage: some View {
        Image(item.images.first ?? "")
            .resizable()
            .frame(width: 108, height: 108)
            .cornerRadius(12)
    }
    
    private var starRating: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) {
                index in Image(index < item.rating ? "starActive" : "starNoActive")
                    .font(.system(size: 12))
            }
        }
    }
    
    private var price: some View {
        VStack(alignment: .leading) {
            Text("Цена")
                .font(.regular13)
            Text("\(item.price.formatted()) ETH")
                .font(.bold17)
        }
    }
}

#Preview {
    CartCellView(item: Nft.mock)
        .background(Color.pink.opacity(0.7))
        .environmentObject(CartViewViewModel())
}
