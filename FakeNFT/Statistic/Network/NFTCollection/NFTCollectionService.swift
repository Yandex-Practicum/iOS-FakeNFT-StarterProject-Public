//
//  NFTCollectionService.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 4/3/25.
//
import Foundation

final class NFTCollectionService {
    // MARK: - Public Properties
    static let shared = NFTCollectionService()
    static let didChangeNotification = Notification.Name(rawValue: "NFTCollectionServiceDidChange")
    // MARK: - Private Properties
    private(set) var nfts: [NFTCollectionModel] = []
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    // MARK: - Initializers
    private init() {}
    // MARK: - Public Methods
    func fetchNFT(with ids: [String]) {
        assert(Thread.isMainThread)
        
        // Очищаем предыдущие данные
        self.nfts.removeAll()
        
        let dispatchGroup = DispatchGroup()
        
        for id in ids {
            dispatchGroup.enter()
            
            guard let request = try? makeNFTRequest(with: id) else {
                dispatchGroup.leave()
                continue
            }
            
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<NFTCollectionResult, Error>) in
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let response):
                    let newNFT = NFTCollectionModel(result: response)
                    DispatchQueue.main.async {
                        self?.nfts.append(newNFT)
                    }
                case .failure(let error):
                    print("Error fetching NFT \(id): \(error)")
                }
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.nfts.sort { $0.id < $1.id } // Сортируем по ID
            NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
        }
    }
    // MARK: - Private Methods
    private func makeNFTRequest(with id: String) throws -> URLRequest? {
        guard let baseUrl = URL(string: RequestConstants.baseURL) else {
            throw NFTCollectionServiceErrors.invalidURL
        }
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else {
            throw NFTCollectionServiceErrors.invalidURL
        }
        
        components.path = "/api/v1/nft/\(id)"
        
        guard let url = components.url else {
            throw NFTCollectionServiceErrors.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}
