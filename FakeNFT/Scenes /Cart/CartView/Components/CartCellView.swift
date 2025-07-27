//
//  CollectionCellView.swift
//  FakeNFT
//
//  Created by Max on 26.05.2025.
//

import SwiftUI

struct CartCellView: View {
    
    let item: Nft
    let onDeleteTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            image
            VStack(alignment: .leading) {
                nftName
                starRating
                price
            }
            Spacer()
            
            Button(action: onDeleteTapped) {
                Image("cartDelete")
            }
        }
        .padding()
        .frame(maxHeight: 140)
    }
    
    private var nftName: some View {
        Text(item.name)
            .font(.bold17)
    }
    
    private var image: some View {
            AsyncImage(url: URL(string: item.images.first ?? "")) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                        ProgressView()
                    }
                    .frame(width: 108, height: 108)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 108, height: 108)
                        .clipped()
                        .cornerRadius(12)

                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 108, height: 108)

                @unknown default:
                    EmptyView()
                }
            }
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
    CartCellView(item: Nft.mock, onDeleteTapped: {})
        .background(Color.pink.opacity(0.7))
}
