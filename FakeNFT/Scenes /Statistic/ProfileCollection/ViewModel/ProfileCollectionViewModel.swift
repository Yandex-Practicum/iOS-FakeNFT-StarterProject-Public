//
//  RatingViewModel.swift
//  FakeNFT
//
//  Created by macOS on 23.06.2023.
//

import Foundation

final class ProfileCollectionViewModel {
    
    @Observable
    private(set) var nftList: [Nft] = []
    
    @Observable
    private(set) var isLoading: Bool = false
    
    @Observable
    private(set) var errorMessage: String? = nil
    
    private let nftService: NftServiceProtocol
    
    init(nftService: NftServiceProtocol = NftNetworkService()) {
        self.nftService = nftService
    }
    
    func getNftCollection(nftIdList: [Int]) {
        isLoading = true
        
        nftService.getNftList(nftIds: nftIdList) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let nftList):
                    self?.nftList = nftList
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}
