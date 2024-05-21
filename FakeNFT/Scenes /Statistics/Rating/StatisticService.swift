//
//  StatisticService.swift
//  FakeNFT
//
//  Created by Сергей on 07.05.2024.
//

import UIKit
import Alamofire

final class StatisticService {
    static let didChangeNotification = Notification.Name(rawValue: "StatisticServiceDidChange")
    static let shared = StatisticService()
    private init() {}
    private var lastLoadedPage: Int = 0
    private var page: Int?

    func fetchNextPage(completion: @escaping (Result<[Person], Error>) -> Void) {

        let headers: HTTPHeaders = [
            NetworkConstants.acceptKey: NetworkConstants.acceptValue,
            NetworkConstants.tokenKey: NetworkConstants.tokenValue
        ]

        let nextPageUrl = "\(NetworkConstants.baseURL)/api/v1/users?page=\(lastLoadedPage)&size=10"

        AF.request(nextPageUrl, headers: headers).responseDecodable(of: [Person].self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let user):
                    completion(.success(user))
                    self.lastLoadedPage += 1
                    NotificationCenter.default
                        .post(name: StatisticService.didChangeNotification,
                              object: self
                        )

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
