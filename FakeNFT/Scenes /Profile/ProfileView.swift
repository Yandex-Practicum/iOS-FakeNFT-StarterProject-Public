//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Mac on 11.06.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    @State private var isPresenting = false
    
    private let profileService: ProfileService
    private let nftsService: NftService
    private let likesService: LikesService
    
    init(profileService: ProfileService, nftsService: NftService, likesService: LikesService) {
        self.profileService = profileService
        self.nftsService = nftsService
        self.likesService = likesService
        _viewModel = StateObject(wrappedValue: ProfileViewModel(profileService: profileService, nftsService: nftsService, likesService: likesService))
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                HStack{
                    Spacer()
                    Button("",systemImage: "square.and.pencil"){
                        isPresenting = true
                    }
                    .foregroundStyle(Color.blackDay)
                    .frame(width: 42,height: 42)
                    .font(.system(size: 26, weight: .semibold))
                    .sheet(isPresented: $isPresenting) {
                       FullScreenModalView(viewModel: viewModel)
                        
                    }
                    
                    
                }
                
                userInfo
                
                Text("\(viewModel.description)")
                    .font(.custom("SFProText-Regular", size: 13))
                    .foregroundStyle(Color.blackDay)
                    .padding(.top)
                Button(action: { }) {
                    Text("\(viewModel.link)")
                        .padding(.top, 6)
                        .padding(.bottom)
                    
                }
                NavigationLink(destination: UserNFT().environmentObject(viewModel)){
                    NftsButton(nfts: viewModel.nfts.count, name: "Мои NFT")
                }
                NavigationLink(destination: FavouritesView().environmentObject(viewModel)) {
                    NftsButton(nfts: viewModel.favoritesNfts.count, name: "Избранные NFT")
                }
                
                NavigationLink(destination: AboutUser()){
                    AboutButton(name: "О разработчике")
                }
                
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            .task {
                await viewModel.fetchProfile()
            }
            
        }
        
    }
    
    
    var userInfo: some View {
        
        
        HStack() {
//            AsyncImage(url: URL(string: viewModel.avatar)) { image in
//                image.resizable()
//            } placeholder: {
//                ProgressView()
//            }
////            .frame(width: 120,height: 120)
//            .frame(width: 70, height: 70)
//            .clipShape(.circle)
            if let data = viewModel.imageData, let uiImage = UIImage(data: data) {
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
            Text("\(viewModel.name)")
                .font(.bold22)
                .foregroundStyle(Color.blackDay)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        
        
        
    }
    
}

#Preview {
//    ProfileView(profileService: ProfileServiceImpl(networkClient: DefaultNetworkClient()))
}
