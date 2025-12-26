//
//  SwiftUIView.swift
//  FakeNFT
//
//  Created by Mac on 13.06.2025.
//

import SwiftUI


struct AboutButton: View {
    
    let name: String
    var body: some View {
        HStack{
            Group{
                Text("\(name)")
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
    AboutButton(name: "О разработчике")
}
