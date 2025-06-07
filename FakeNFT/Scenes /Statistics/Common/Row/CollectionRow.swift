//
//  CollectionRow.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import SwiftUI

struct CollectionRow: View {
    
    // MARK: - Properties
    
    let index: Int
    var likeTapHandler: (Int) -> Void
    var cartTapHandler: (Int) -> Void
    
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
            AsyncImage(url: URL(string: "url")) { phase in // TODO: url
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(
                            width: StatisticsConstants.collectionRowSize,
                            height: StatisticsConstants.collectionRowSize
                        )
                        .aspectRatio(contentMode: .fill)
                        .background(
                            RoundedRectangle(cornerRadius: StatisticsConstants.cornerRadiusSmall)
                        )
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
                    likeTapHandler(index)
                } label: {
                    Image("likeNoActive") // TODO: ? "likeActive" : "likeNoActive"
                }
            }
        }
    }
    
    private var ratingView: some View {
        HStack(spacing: 2) {
            let rating = 4 // TODO: rating
            ForEach(1..<6) { index in
                Image(index <= rating ? "starActive" : "starNoActive")
            }
            Spacer()
        }
    }
    
    private var nftInfo: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading) {
                Text("Archie")
                    .font(.bold17)
                    .lineLimit(1)
                Text("1,78 ETH") // TODO: "\(price) ETH"
                    .font(.medium10)
            }
            .foregroundStyle(Color.blackDay) // TODO: color
            Spacer()
            Button {
                cartTapHandler(index)
            } label: {
                Image("cartAdd") // TODO: ? "cartAdd" : "cartDelete"
            }
        }
    }
}

#Preview {
    CollectionRow(index: 1, likeTapHandler: {_ in }, cartTapHandler: {_ in})
}
