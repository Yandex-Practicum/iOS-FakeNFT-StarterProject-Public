//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Mac on 12.06.2025.
//

import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @AppStorage("userData") private var storedData: Data = Data()
    
    @Published var name: String = ""
    @Published var avatar: String = ""
    @Published var description: String = ""
    @Published var link: String = ""
    @Published var nfts: [Nft] = []
    @Published var favoritesNfts: [Nft] = []
    @Published var imageData: Data?

    
    enum SortOption: String, CaseIterable, Identifiable {
        case name = "По названию"
        case price = "По цене"
        case rating = "По рейтингу"
        
        var id: String { rawValue }
    }
    @AppStorage("selectedSortOption") private var storedSortOption: String = SortOption.name.rawValue

    private var userLikes = UserLikes(likes: [])
    private var didLoadNFTs = false
    
    private let profileService: ProfileService
    private let nftsService: NftService
    private let likesService: LikesService
    
    var selectedSortOption: SortOption {
        get{ SortOption(rawValue: storedSortOption) ?? .name}
        set { storedSortOption = newValue.rawValue }
    }
    
    var sortedNFTs: [Nft] {
        switch selectedSortOption {
        case .name:
            return nfts.sorted { $0.name < $1.name }
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        }
    }
    init(profileService: ProfileService, nftsService: NftService, likesService: LikesService) {
        self.profileService = profileService
        self.nftsService = nftsService
        self.likesService = likesService
    }
    
    func save(name: String, description: String, link: String, imageData: Data?) {
        let newData = UserData(name: name, description: description, link: link, imageData: imageData)
            if let encoded = try? JSONEncoder().encode(newData) {
                storedData = encoded
                self.name = name
                self.description = description
                self.link = link
                self.imageData = imageData
            }
        }
    
    func fetchProfile() async  {
        await profileService.fetchProfile { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let fetchedProfile):
                self.name = fetchedProfile.name
                self.avatar = fetchedProfile.avatar
                self.description = fetchedProfile.description ?? ""
                self.link = fetchedProfile.website
                
                if !didLoadNFTs {
                    fetchOwnNfts(fetchedProfile.nfts)
                    fetchFavoritesNfts(fetchedProfile.likes)
                    didLoadNFTs = true
                }
                
            case .failure(let error):
                print("Ошибка загрузки профиля: \(error.localizedDescription)")
            }
        }
    }
    
    func isLiked(_ nft: Nft) -> Bool{
        favoritesNfts.contains(where: { $0.id == nft.id})
    }
    
    func toggleLike(for nft: Nft) {
        print("nachalo: \(userLikes.likes.count)")
        userLikes = UserLikes(likes: favoritesNfts.map { $0.id })
        print("loaded: \(userLikes.likes.count)")
        
        likesService.updateLikes(likes: userLikes) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                if let index = self.favoritesNfts.firstIndex(of: nft) {
                    self.favoritesNfts.remove(at: index)
                } else {
                    self.favoritesNfts.append(nft)
                }
                print("SUCCESS: \(self.userLikes.likes.count)")
                break
            case .failure(let error):
                print("Ошибка при обновлении лайков: \(error.localizedDescription)")
                print("ERROR: \(self.userLikes.likes.count)")
            }
        }
    }
    
    private func fetchOwnNfts(_ nftIds: [String]) {
        nftIds.forEach { id in
            nftsService.loadNft(id: id) {
                switch $0 {
                case .success(let nft):
                    self.nfts.append(nft)
                    
                case .failure(let error):
                    print("Ошибка загрузки NFT: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchFavoritesNfts(_ nftIds: [String]) {
        nftIds.forEach { id in
            nftsService.loadNft(id: id) {
                switch $0 {
                case .success(let nft):
                    self.favoritesNfts.append(nft)
                    
                case .failure(let error):
                    print("Ошибка загрузки NFT: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchLikedNfts(_ nftIds: [String]) {
        
    }
    
}


