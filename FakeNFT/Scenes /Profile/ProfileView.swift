//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Mac on 11.06.2025.
//

import SwiftUI

struct ProfileView: View {
    @State private var isPresenting = false
    
    
    @AppStorage("name") var name: String = "Joaquin Phoenix"
    
    @AppStorage("description") var description: String = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."
    
    @AppStorage("link") var link: String = "link"
    
    @AppStorage("savedImage") private var imageData: Data?
    func send(){
        
    }
    var body: some View {
        
        content
        
    }
    
    var content: some View {
        NavigationView{
            VStack(alignment: .leading) {
                HStack{
                    Spacer()
                    Button("",systemImage: "square.and.pencil"){
                        isPresenting = true
                    }
                    .sheet(isPresented: $isPresenting) {
                        FullScreenModalView()
                            
                    }
                    .foregroundStyle(Color.blackDay)
                    .frame(width: 42,height: 42)
                    .font(.system(size: 26, weight: .semibold))
                   
                }
                
                userInfo
                Text("\(description)")
                    .font(.custom("SFProText-Regular", size: 13))
                    .foregroundStyle(Color.blackDay)
                    .padding(.top)
                Button(action: send) {
                    Text("\(link)")
                        .padding(.top, 6)
                        .padding(.bottom)
                        
                        }
                
                NavigationLink(destination: UserNft()){
                    NftsButton(nfts: 122, name: "Мои NFT")
                }
                
                
                NavigationLink(destination: Favourites()){
                    NftsButton(nfts: 11, name: "Избранные NFT")
                }
                NavigationLink(destination: AboutUser()){
                    AboutButton(name: "О разработчике")
                }
               
               
                
               
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal)

        }

        
    }
    
    
    var userInfo: some View {
        
        
        HStack(spacing: .zero){
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120,height: 120)
                    .frame(width: 70, height: 70)
                    .clipShape(.circle)

            } else {
                Image(.profilePhoto)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100,height: 100)
                    .frame(width: 70, height: 70)
                    .clipShape(.circle)
            }
            Text("\(name)")
                .font(.bold22)
                .foregroundStyle(Color.blackDay)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        
        
        
        
        
    }
    
}

#Preview {
    ProfileView()
}
