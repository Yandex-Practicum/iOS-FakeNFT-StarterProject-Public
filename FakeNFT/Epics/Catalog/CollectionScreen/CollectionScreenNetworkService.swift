//
//  CollectionScreenNetworkService.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 10.08.2023.
//

import Foundation

final class CollectionScreenNetworkService {
    static let shared = CollectionScreenNetworkService()
    static let nftsDidChangeNotification = Notification.Name(rawValue: "NftsCollectionScreenNetworkServiceDidChange")
    static let authorDidChangeNotification = Notification.Name(rawValue: "AuthorCollectionScreenNetworkServiceDidChange")
    
    private(set) var nfts: [NftModel] = []
    private var ids: [String]?
    private var position: Int?
    private(set) var author: AuthorModel?
    
    private let defaultNetworkClient = DefaultNetworkClient()
    private var nftTask: NetworkTask?
    private var authorTask: NetworkTask?
    
    private init() {}
    
    func fetchAuthor(id: String) {
        assert(Thread.isMainThread)
        
        if authorTask != nil {
            return
        }
        
        let request = AuthorRequest(httpMethod: .get, id: id)
        
        let task = defaultNetworkClient.send(request: request, type: AuthorModel.self, onResponse: authorResultHandler)
        
        authorTask = task
    }
    
    private func authorResultHandler(_ res: Result<AuthorModel, Error>) {
        switch res {
        case .success(let data):
            author = data
            authorTask = nil
            NotificationCenter.default.post(name: CollectionScreenNetworkService.authorDidChangeNotification, object: self)
        case .failure(let error):
            print(error)
        }
    }
    
    func fetchNft(ids: [String], position: Int) {
        
        if position == 0 {
            nfts = []
        }
        
        if nftTask != nil {
            return
        }
        
        self.ids = ids
        self.position = position
        
        let request = NftRequest(httpMethod: .get, id: ids[position])
        
        let task = defaultNetworkClient.send(request: request, type: NftModel.self, onResponse: nftResultHandler)
        
        nftTask = task
    }
    
    private func nftResultHandler(_ res: Result<NftModel, Error>) {
        switch res {
        case .success(let data):
            nfts.append(data)
            nftTask = nil
            NotificationCenter.default.post(name: CollectionScreenNetworkService.nftsDidChangeNotification, object: self)
            if position! < ids!.count - 1 {
                fetchNft(ids: ids!, position: position! + 1)
            }
        case .failure(let error):
            print(error)
        }
    }
}

final class NftRequest: NetworkRequest {
    private var id: String
    var httpMethod: HttpMethod
    var endpoint: URL? {
        let host = "64858e8ba795d24810b71189.mockapi.io"
        return URL(string: "https://\(host)/api/v1/nft/\(id)")
    }
    
    init(httpMethod: HttpMethod, id: String) {
        self.httpMethod = httpMethod
        self.id = id
    }
}

final class AuthorRequest: NetworkRequest {
    private var id: String
    var httpMethod: HttpMethod
    var endpoint: URL? {
        let host = "64858e8ba795d24810b71189.mockapi.io"
        return URL(string: "https://\(host)/api/v1/users/\(id)")
    }
    
    init(httpMethod: HttpMethod, id: String) {
        self.httpMethod = httpMethod
        self.id = id
    }
}
