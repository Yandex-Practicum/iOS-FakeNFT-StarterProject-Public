//
//  NftRow.swift
//  FakeNFT
//
//  Created by Mac on 18.06.2025.
//

import SwiftUI

struct NftRow: View {
    
    // MARK: - Properties
    let name: String
    let nft: NftInfo
    let userLikes: UserLikes
    let userOrders: UserOrders
    var likeTapHandler: (NftInfo) -> Void
    var cartTapHandler: (NftInfo) -> Void
    
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
                    likeTapHandler(nft)
                } label: {
                    Image(userLikes.likes.contains(nft.id) ? "likeActive" : "likeNoActive")
                }
            }
        }
    }
    
    private var ratingView: some View {
        VStack(alignment: .leading, spacing: 6){
            Text("\(name)")
                .font(.headline)
            HStack(spacing: 2) {
                       let rating = nft.rating
                       ForEach(1..<6) { index in
                           Image(index <= rating ? "starActive" : "starNoActive")
                       }
                      
                   }
            Text("от Jhon Doe")
            
        }

        
    }
    

}


#Preview {
    NftRow(
        name: "Lilo", nft: NftInfo(
            id: "",
            name: "",
            images: [""],
            rating: 4,
            price: 1.79
        ),
        userLikes: UserLikes(likes: []),
        userOrders: UserOrders(nfts: []),
        likeTapHandler: {_ in },
        cartTapHandler: {_ in}
    )
}
