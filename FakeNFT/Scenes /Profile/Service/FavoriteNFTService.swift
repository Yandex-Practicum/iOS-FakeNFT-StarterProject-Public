//
//  FavoriteNFTService.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 25.04.2024.
//

import Foundation

final class FavoriteNFTService {
    //MARK:  - Public Properties
    static let shared = FavoriteNFTService()
    
    //MARK:  - Private Properties
    private(set) var NFTs: [NFT]?
    private var urlSession = URLSession.shared
    private var id: String?
    private var urlSessionTask: URLSessionTask?
    
    // MARK: - Initialization
    init(
        NFTs: [NFT]? = nil,
        id: String? = nil,
        urlSessionTask: URLSessionTask? = nil
    ) {
        self.NFTs = NFTs
        self.id = id
        self.urlSessionTask = urlSessionTask
    }
    
    //MARK: - Public Methods
    func fetchNFTs(_ id: String, completion: @escaping (Result<NFT, Error>) -> Void) {
        guard let request = makeFetchNFTRequest(id: id) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<NFT, Error>) in
            switch response {
            case .success(let likes):
                completion(.success(likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Private Methods
    private func makeFetchNFTRequest(id: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConstants.urlScheme
        urlComponents.host  = NetworkConstants.urlHost
        urlComponents.path = NetworkConstants.urlPathNFT + "\(id)"
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(NetworkConstants.tokenKey, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return request
    }
}
