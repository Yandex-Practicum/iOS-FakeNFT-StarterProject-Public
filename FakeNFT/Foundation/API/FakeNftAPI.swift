//
//  FakeNftAPI.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation

struct FakeNftAPI {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = Self.defaultNetworkClient) {
        self.networkClient = networkClient
    }

    static var defaultNetworkClient: NetworkClient {
        let decoder = JSONDecoder()

        let formatter1 = ISO8601DateFormatter()
        formatter1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let formatter2 = ISO8601DateFormatter()
        formatter2.formatOptions = [.withInternetDateTime]

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let date = formatter1.date(from: dateStr) ?? formatter2.date(from: dateStr)

            guard let date else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateStr)")
            }

            return date
        }

        return DefaultNetworkClient(decoder: decoder)
    }
}

// extension FakeNftAPI {
//    func updateProfile(id: Int,
//                       name: String,
//                       description: String,
//                       website: URL,
//                       likes: [Int],
//                       onResponse: @escaping(Result<ProfileModel,Error>) -> Void) -> NetworkTask? {
//        networkClient.send(request: <#T##NetworkRequest#>,
//                           type: <#T##Decodable.Protocol#>,
//                           onResponse: <#T##(Result<Decodable, Error>) -> Void#>)
//    }
//
// }
