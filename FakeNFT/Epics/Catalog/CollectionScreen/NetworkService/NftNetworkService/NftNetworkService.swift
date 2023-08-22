//
//  NftNetworkService.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import Foundation

final class NftNetworkService {
    static let shared = NftNetworkService()
    static let nftNetworkServiceDidChangeNotification = Notification.Name(rawValue: "NftNetworkServiceDidChange")
    
    private(set) var nfts: [NftModel] = []
    
    private let defaultNetworkClient = DefaultNetworkClient()
    private var nftTask: NetworkTask?
    
    private init() {}
    
    func fetchNft(id: String) {
        assert(Thread.isMainThread)
        
        if nftTask != nil {
            return
        }
        
        nfts = []
        
        let request = NftRequest(httpMethod: .get, id: id)
        
        let task = defaultNetworkClient.send(request: request, type: [NftModel].self, onResponse: nftResultHandler)
        
        nftTask = task
    }
    
    private func nftResultHandler(_ res: Result<[NftModel], Error>) {
        switch res {
        case .success(let data):
            nfts.append(contentsOf: data)
            nftTask = nil
            NotificationCenter.default.post(name: NftNetworkService.nftNetworkServiceDidChangeNotification, object: self)
        case .failure(let error):
            print(error)
        }
    }
}
