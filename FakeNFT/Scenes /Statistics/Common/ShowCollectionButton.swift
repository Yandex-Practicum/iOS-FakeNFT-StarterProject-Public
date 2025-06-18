//
//  ShowCollectionButton.swift
//  FakeNFT
//
//  Created by Anastasia on 04.06.2025.
//

import SwiftUI

struct ShowCollectionButton: View {
    
    let nftsCount: Int
    
    var body: some View {
        HStack {
            Group {
                Text("Коллекция NFT")
                Text("(\(nftsCount))")
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .font(.bold17)
            .foregroundColor(Color.blackDay)
        }
        .frame(height: StatisticsConstants.buttonHeightLarge)
    }
}

#Preview {
    ShowCollectionButton(nftsCount: 122)
}
