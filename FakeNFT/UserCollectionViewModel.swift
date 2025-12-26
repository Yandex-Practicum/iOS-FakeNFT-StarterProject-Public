//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

@MainActor
final class UserCollectionViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var nftIds: [String]
    @Published var nftInfo: [NftInfo] = []
    @Published var userLikes = UserLikes(likes: [])
    @Published var userOrders = UserOrders(nfts: [])
    @Published var isLoading: Bool = false
    @Published var isShowingErrorAlert: Bool = false
    
    private let nftInfoService: NftInfoService
    private let likesService: LikesService
    private let userOrdersService: UserOrdersService
    
    // MARK: - Initializers
    
    init(nftIds: [String], service: ServicesAssembly) {
        self.nftIds = nftIds
        self.nftInfoService = service.nftInfoService
        self.likesService = service.likesService
        self.userOrdersService = service.userOrdersService
    }
    
    // MARK: - Public Methods
    
    func loadData() {
        if nftIds.isEmpty { return }
        if !nftInfo.isEmpty { return }
        isLoading = true
        
        let group = DispatchGroup()
        
        loadNftInfo(group)
        loadLikes(group)
        loadUserOrders(group)
        
        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
    
    func updateLike(nftId: String) {
        userLikes = UserLikes(
            likes: updateData(
                array: userLikes.likes,
                nftId: nftId
            ))
        
        likesService.updateLikes(likes: userLikes) { result in
            switch result {
            case .success():
                print("Likes updated")
            case .failure(let error):
                print("Error update: \(error)")
            }
        }
    }
    
    func updateUserOrder(nftId: String) {
        userOrders = UserOrders(
            nfts: updateData(
                array: userOrders.nfts,
                nftId: nftId
            ))
        
        userOrdersService.updateUserOrders(nfts: userOrders) { result in
            switch result {
            case .success():
                print("Orders updated")
            case .failure(let error):
                print("Error update: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadNftInfo(_ group: DispatchGroup) {
        for id in nftIds {
            group.enter()
            nftInfoService.loadNftInfo(id: id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nftInfo):
                    self.nftInfo.append(nftInfo)
                case .failure(let error):
                    print("Error loading nft info: \(error)")
                    self.isShowingErrorAlert = true
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
                print("Error loading likes: \(error)")
                self.isShowingErrorAlert = true
            }
            group.leave()
        }
    }
    
    private func loadUserOrders(_ group: DispatchGroup) {
        group.enter()
        userOrdersService.loadUserOrders() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let orders):
                self.userOrders = orders
            case .failure(let error):
                print("Error loading user orders: \(error)")
                self.isShowingErrorAlert = true
            }
            group.leave()
        }
    }
    
    private func updateData<T: Equatable>(array: [T], nftId: T) -> [T] {
        var updatedArray = array
        if array.contains(nftId) {
            updatedArray.removeAll { $0 == nftId }
        } else {
            updatedArray.append(nftId)
        }
        return updatedArray
    }
}
