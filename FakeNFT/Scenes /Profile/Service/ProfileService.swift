//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 25.04.2024.
//

import Foundation

final class ProfileService {
    //MARK:  - Public Properties
    static let shared = ProfileService()
    
    //MARK:  - Private Properties
    private var urlSession = URLSession.shared
    private var token: String?
    private var urlSessionTask: URLSessionTask?
    private (set) var profile: Profile?
    
    // MARK: - Initialization
    init(
        profile: Profile? = nil,
        token: String? = nil,
        urlSessionTask: URLSessionTask? = nil
    ) {
        self.profile = profile
        self.token = token
        self.urlSessionTask = urlSessionTask
    }
    
    //MARK: - Public Methods
    func fetchProfile() {
        self.fetchProfile { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                fatalError("Error: \(error)")
            }
        }
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = makeFetchProfileRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<Profile, Error>) in
            switch response {
            case .success(let profileResult):
                completion(.success(profileResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Private Methods
    private func makeFetchProfileRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConstants.urlScheme
        urlComponents.host  = NetworkConstants.urlHost
        urlComponents.path = NetworkConstants.urlPath
        
        guard let url = urlComponents.url else {return nil}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(NetworkConstants.tokenKey, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return request
    }
}
