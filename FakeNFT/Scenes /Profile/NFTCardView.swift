//
//  NFTCardView.swift
//  FakeNFT
//
//  Created by Mac on 16.07.2025.
//

import SwiftUI

struct NFTCardView: View {
    let nft: NFT

    var body: some View {
        HStack {
            // Временное изображение-заглушка
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.pink)
                .frame(width: 108, height: 108)
            

            VStack(alignment: .leading) {
                Text(nft.name)
                    .font(.headline)

                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < nft.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }

                Text("от Jhon Doe")
                    
            }
            .padding(.leading, 15)
            

            Spacer()
            VStack(alignment: .leading){
                Text("Цена")
                
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.headline)
            }
        }
        .padding()
        .cornerRadius(12)
    }
}

#Preview {
    NFTCardView(nft: NFT.init(name: "Q", price: 1.1, rating: 4))
}
