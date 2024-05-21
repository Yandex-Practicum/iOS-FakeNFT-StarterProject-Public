//
//  UserNFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 02.05.2024.
//

import Foundation
import Alamofire

final class UserNFTService {

    static let shared = UserNFTService()
    private init() {}

    var nftsIDs: [String] = []
    var visibleNFT: [NFTModel] = []
    var nft: NFTModel?

    func getNFT(complition: @escaping () -> Void ) {
        let headers: HTTPHeaders = [
            NetworkConstants.acceptKey: NetworkConstants.acceptValue,
            NetworkConstants.tokenKey: NetworkConstants.tokenValue
        ]

        let requests = nftsIDs.map { id in
            return AF.request("\(NetworkConstants.baseURL)/api/v1/nft/\(id)", headers: headers)
        }

        let group = DispatchGroup()

        for request in requests {
            group.enter()
            request.responseDecodable(of: NFTModel.self) { response in
                defer {
                    group.leave()
                }

                switch response.result {
                case .success(let model):
                    self.visibleNFT.append(model)
                case .failure(let error):
                    print(error)
                }
            }
        }

        group.notify(queue: .main) {

            complition()
        }
    }

    func changeLike(newLikes: [String], profile: ProfileModel, completion: @escaping (Result<Void, Error>) -> Void) {

        guard let nft = self.nft else { return }
        let likesString = newLikes.joined(separator: ",")
        let url = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1"
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Practicum-Mobile-Token": "9db803ac-6777-4dc6-9be2-d8eaa53129a9"
        ]

        var parameters: [String: String] = [: ]

        if profile.likes.count == 1 && profile.likes.contains(nft.id) {
            parameters = ["likes": "null"]
        } else {
            parameters = ["likes": likesString]
        }

        AF.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func changeCart(newCart: [String], cart: OrderModel, completion: @escaping (Result<Void, Error>) -> Void) {

        guard let nft = self.nft else { return }
        let cartString = newCart.joined(separator: ",")
        let url = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1"
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Practicum-Mobile-Token": "9db803ac-6777-4dc6-9be2-d8eaa53129a9"
        ]
        let parameters = ["nfts": cartString]

        if cart.nfts.count == 1 && cart.nfts.first == nft.id {
            AF.request(url, method: .put, encoding: URLEncoding.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        } else {
            AF.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    }

    func getProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        let headers: HTTPHeaders = [
            NetworkConstants.acceptKey: NetworkConstants.acceptValue,
            NetworkConstants.tokenKey: NetworkConstants.tokenValue
        ]

        let url = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1"

        AF.request(url, headers: headers).responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCart(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let headers: HTTPHeaders = [
            NetworkConstants.acceptKey: NetworkConstants.acceptValue,
            NetworkConstants.tokenKey: NetworkConstants.tokenValue
        ]

        let url = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1"

        AF.request(url, headers: headers).responseDecodable(of: OrderModel.self) { response in
            switch response.result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
