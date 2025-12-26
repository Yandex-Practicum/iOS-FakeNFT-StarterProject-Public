//
//  NFTCardView.swift
//  FakeNFT
//
//  Created by Mac on 16.07.2025.
//

import SwiftUI

struct NFTCardView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    let nft: Nft
    
    var body: some View {
        HStack {
            
            ZStack(alignment: .topTrailing){
            if let url = URL(string: nft.images.first ?? "") {
                AsyncImage(url: url) { image in
                    image.image?.resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 108, height: 108)
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
//    let nft = Nft(id: "lkjkjkj", name: "sdf", images: [""], description: "sdf", rating: 1, price: 1.2, author: "sdfsdf")
//    NFTCardView(nft: nft)
}
