//
//  NftRow.swift
//  FakeNFT
//
//  Created by Mac on 18.06.2025.
//

import SwiftUI

struct NftRow: View {
    
    // MARK: - Properties
   
    let nft: NftInfo

    
    // MARK: - Content
    
    var body: some View {
        HStack(){
           
                image
                .frame(width: 109)
                
            
            
            HStack(){
                
                    ratingView
                    .padding()
                Spacer()
                VStack(alignment: .leading){
                    Text("Цена")
                    
                    Text("\(nft.price, specifier: "%.2f") ETH")
                        .font(.headline)
                }
                .padding()
                
                
                
                
                
        
            }
            
        }.padding()
    
         
    }
    
    // MARK: - View
    

    
    private var image: some View {
        ZStack(alignment: .top) {
            AsyncImage(url: URL(string: nft.images.first ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(
                            width: StatisticsConstants.collectionRowSize,
                            height: StatisticsConstants.collectionRowSize
                        )
                        .aspectRatio(contentMode: .fill)
                        .clipShape(.rect(cornerRadius: StatisticsConstants.cornerRadiusSmall))
                case .failure, .empty:
                    RoundedRectangle(cornerRadius: StatisticsConstants.cornerRadiusSmall)
                        .fill(Color.lightGrayDay)
                        .frame(
                            width: StatisticsConstants.collectionRowSize,
                            height: StatisticsConstants.collectionRowSize
                        )
                default:
                    EmptyView()
                }
            }
            HStack {
                Spacer()
                Button {
                   // likeTapHandler(nft)
                } label: {
//                    Image(userLikes.likes.contains(nft.id) ? "likeActive" : "likeNoActive")
                }
            }
        }
    }
    
    private var ratingView: some View {
        VStack(alignment: .leading, spacing: 6){
            Text("\(nft.name)")
                .font(.headline)
            HStack(spacing: 2) {
                       let rating = nft.rating
                       ForEach(1..<6) { index in
                           Image(index <= rating ? "starActive" : "starNoActive")
                       }
                      
                   }
            Text("ds")
            
        }

        
    }
    

}


#Preview{
    NftRow(nft: NftInfo.init(id: "1", name: "WD", images: ["String"], rating: 1, price: 2.1))
}
