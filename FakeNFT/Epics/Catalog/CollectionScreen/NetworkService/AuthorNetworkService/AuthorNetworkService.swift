//
//  AuthorNetworkService.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 10.08.2023.
//

import Foundation

final class AuthorNetworkService {
    static let shared = AuthorNetworkService()
    static let authorNetworkServiceDidChangeNotification = Notification.Name(rawValue: "AuthorNetworkServiceDidChange")
    
    private(set) var author: AuthorModel?
    
    private let defaultNetworkClient = DefaultNetworkClient()
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
            NotificationCenter.default.post(name: AuthorNetworkService.authorNetworkServiceDidChangeNotification, object: self)
        case .failure(let error):
            print(error)
        }
    }
}
