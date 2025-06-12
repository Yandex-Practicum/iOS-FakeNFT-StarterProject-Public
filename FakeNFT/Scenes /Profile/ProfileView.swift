//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Mac on 11.06.2025.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            
            HStack {
                        Image(.blueSomething)
                            .resizable()
                            .frame(width: 100, height: 100)
                        Spacer()
                        Text("Разработчик")
                        Spacer()
                    }
                    .border(.green)
                    .padding()
            
                }
        Text("Some Text")

        }
        
}

#Preview {
    ProfileView()
}
