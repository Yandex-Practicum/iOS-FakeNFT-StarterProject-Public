//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

@MainActor
final class UserCollectionViewModel: ObservableObject {
    @Published var nftIds: [String]
    @Published var nftInfo: [NftInfo] = []
    @Published var userLikes = UserLikes(likes: [])
    @Published var isLoading: Bool = false
    
    private let nftInfoService: NftInfoService
    private let likesService: LikesService
    
    init(nftIds: [String], service: ServicesAssembly) {
        self.nftIds = nftIds
        self.nftInfoService = service.nftInfoService
        self.likesService = service.likesService
    }
    
    func loadData() {
        if !nftInfo.isEmpty { return }
        isLoading = true
        
        let group = DispatchGroup()
        
        loadNftInfo(group)
        loadLikes(group)
        
        group.notify(queue: .main) {
            self.isLoading = false
            print(self.userLikes.likes)
        }
    }
    
    private func loadNftInfo(_ group: DispatchGroup) {
        for id in nftIds {
            group.enter()
            nftInfoService.loadNftInfo(id: id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nftInfo):
                    self.nftInfo.append(nftInfo)
                case .failure(let error):
                    print("Error: \(error)") // TODO: alert
                }
                group.leave()
            }
        }
    }
    
    private func loadLikes(_ group: DispatchGroup) {
        group.enter()
        likesService.loadLikes() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let likes):
                self.userLikes = likes
            case .failure(let error):
                print("Error: \(error)") // TODO: alert
            }
            group.leave()
        }
    }
}
