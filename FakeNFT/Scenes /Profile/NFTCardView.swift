//
//  NFTCardView.swift
//  FakeNFT
//
//  Created by Mac on 16.07.2025.
//

import SwiftUI

struct NFTCardView: View {
    let nft: NFT
    @EnvironmentObject var viewModel: NFTViewModel


    var body: some View {
        HStack {
            
            ZStack(alignment: .topTrailing){
            if let url = URL(string: nft.images.first ?? "") {
                AsyncImage(url: url) { image in
                    image.image?.resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
                // Временное изображение-заглушка
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 108, height: 108)
                Button(action: {
                    viewModel.toggleLike(for: nft)
                }) {
                    Image(systemName:"heart.fill")
                        .foregroundColor(viewModel.isLiked(nft) ? .red : .white)
                        .padding(10)
                }
                .buttonStyle(.plain)
                
            }
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
    NFTCardView(nft: NFT.init(id: UUID(), name: "Q", price: 1.1, rating: 4, images: [""]))
}
