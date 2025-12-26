//
//  NftsButton.swift
//  FakeNFT
//
//  Created by Mac on 13.06.2025.
//

import SwiftUI

struct NftsButton: View {
    
    let nfts: Int
    let name: String
    var body: some View {
        HStack{
            Group{
                Text("\(name)")
                Text("(\(nfts))")
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
    NftsButton(nfts: 122, name: "Мои NFT")
}
