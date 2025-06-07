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
    @Published var isLoading: Bool = false
    
    private let nftInfoService: NftInfoService
    
    init(nftIds: [String], nftInfoService: NftInfoService) {
        self.nftIds = nftIds
        self.nftInfoService = nftInfoService
    }
    
    func loadData() {
        if !nftInfo.isEmpty { return }
        isLoading = true
        
        let group = DispatchGroup()
        
        loadNftInfo(group)
        
        group.notify(queue: .main) {
            self.isLoading = false
            print(self.nftInfo)
        }
    }
    
    func loadNftInfo(_ group: DispatchGroup) {
        for id in nftIds {
            group.enter()
            nftInfoService.loadNftInfo(id: id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nftInfo):
                    self.nftInfo.append(nftInfo)
                case .failure(let error):
                    print("Error: \(error)")
                }
                group.leave()
            }
        }
    }
}
