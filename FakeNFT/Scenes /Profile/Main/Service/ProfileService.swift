//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Dinara on 24.03.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var urlSession = URLSession.shared
    private var token: String?
    private var urlSessionTask: URLSessionTask?
    private let tokenKey = "6209b976-c7aa-4061-8574-573765a55e71"

    private init(
        profile: Profile? = nil,
        token: String? = nil,
        urlSessionTask: URLSessionTask? = nil
    ) {
        self.profile = profile
        self.token = token
        self.urlSessionTask = urlSessionTask
    }

    func fetchProfile(_ token: String) {
        self.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                fatalError("Error: \(error)")
            }
        }
    }

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = makeFetchProfileRequest(token: token) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        urlSessionTask = urlSession.objectTask(for: request) { [weak self] (response: Result<Profile, Error>) in
            switch response {
            case .success(let profileResult):
                let profile = Profile(
                    name: profileResult.name,
                    avatar: profileResult.avatar,
                    description: profileResult.description,
                    website: profileResult.website,
                    nfts: profileResult.nfts,
                    likes: profileResult.likes,
                    id: profileResult.id
                )
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ProfileService {
    func makeFetchProfileRequest(token: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host  = "64858e8ba795d24810b71189.mockapi.io"
        urlComponents.path = "/api/v1/profile/1"

        guard let url = urlComponents.url else {
            fatalError("Failed to create URL")
        }

        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }
}
