//
//  CatalogNetworkService.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 10.08.2023.
//

import Foundation

final class CatalogNetworkService {
    static let shared = CatalogNetworkService()
    static let didChangeNotification = Notification.Name(rawValue: "CatalogNetworkServiceDidChange")
    
    private(set) var collections: [CatalogDataModel] = []
    
    private let defaultNetworkClient = DefaultNetworkClient()
    private var task: NetworkTask?
    private var lastLoadedPage: Int?
    
    private init() {}
    
    func fetchCollectionNextPage() {
        assert(Thread.isMainThread)
        
        if task != nil {
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let request = CatalogRequest(nextPage: "\(nextPage)", httpMethod: HttpMethod.get)
        
        let task = defaultNetworkClient.send(request: request, type: [CatalogDataModel].self, onResponse: resultHandler)
                
        self.task = task
    }
    
    private func resultHandler(_ res: Result<[CatalogDataModel], Error>) {
        switch res {
        case .success(let data):
            collections.append(contentsOf: data)
            if lastLoadedPage == nil {
                lastLoadedPage = 1
            } else {
                lastLoadedPage! += 1
            }
            task = nil
            NotificationCenter.default.post(name: CatalogNetworkService.didChangeNotification, object: self)
        case .failure(let error):
            print(error)
        }
    }
}

final class CatalogRequest: NetworkRequest {
    private var nextPage: String
    
    var httpMethod: HttpMethod
    var endpoint: URL? {
        let host = "64858e8ba795d24810b71189.mockapi.io"
        
        var urlComponents = URLComponents(string: "https://\(host)/api/v1/collections")
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: nextPage),
            URLQueryItem(name: "limit", value: "10")
        ]
        return urlComponents?.url
    }
    
    init(nextPage: String, httpMethod: HttpMethod) {
        self.nextPage = nextPage
        self.httpMethod = httpMethod
    }
}
