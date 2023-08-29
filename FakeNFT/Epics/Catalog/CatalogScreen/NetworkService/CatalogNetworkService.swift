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
    private(set) var isPaginationDoesntEnd = true
    
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
            if !data.isEmpty {
                if (data.count % 10) > 0 {
                    isPaginationDoesntEnd = false
                }
                collections.append(contentsOf: data)
                if lastLoadedPage == nil {
                    lastLoadedPage = 1
                } else {
                    lastLoadedPage! += 1
                }
            } else {
                isPaginationDoesntEnd = false
            }
            task = nil
            NotificationCenter.default.post(name: CatalogNetworkService.didChangeNotification, object: self)
        case .failure(let error):
            print(error)
        }
    }
}
