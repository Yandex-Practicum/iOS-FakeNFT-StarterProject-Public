//
//  CollectionRow.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import SwiftUI

struct CollectionRow: View {
    
    // MARK: - Properties
    
    let nft: NftInfo
    let userLikes: UserLikes
    let userOrders: UserOrders
    var likeTapHandler: (NftInfo) -> Void
    var cartTapHandler: (NftInfo) -> Void
    
    // MARK: - Content
    
    var body: some View {
        content
    }
    
    // MARK: - View
    
    private var content: some View {
        VStack(spacing: .zero) {
            image
            ratingView
                .padding(.top, StatisticsConstants.anchorSmall)
            nftInfo
                .padding(.top, StatisticsConstants.rowAnchorSmall)
                .padding(.bottom, StatisticsConstants.rowAnchorMedium)
        }
        .frame(width: StatisticsConstants.collectionRowSize)
    }
    
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
        HStack(spacing: 2) {
            let rating = nft.rating
            ForEach(1..<6) { index in
                Image(index <= rating ? "starActive" : "starNoActive")
            }
            Spacer()
        }
    }
    
    private var nftInfo: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading) {
                Text(nft.name)
                    .font(.bold17)
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.medium10)
            }
            .foregroundStyle(Color.blackDay)
            Spacer()
            Button {
                cartTapHandler(nft)
            } label: {
                Image(userOrders.nfts.contains(nft.id) ? "cartDelete" : "cartAdd")
            }
        }
    }
}

#Preview {
    CollectionRow(
        nft: NftInfo(
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
