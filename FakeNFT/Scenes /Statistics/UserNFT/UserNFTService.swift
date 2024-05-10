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
    
    func getNFT(complition: @escaping () -> Void ) {
        let headers: HTTPHeaders = [
            NetworkConstants.acceptKey : NetworkConstants.acceptValue,
            NetworkConstants.tokenKey : NetworkConstants.tokenValue
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
    
    func putLike(newLike: String)  {
//        var likes: [String] = []
        let headers: HTTPHeaders = [
            NetworkConstants.acceptKey : NetworkConstants.acceptValue,
            NetworkConstants.tokenKey : NetworkConstants.tokenValue,
            NetworkConstants.contentType : NetworkConstants.contentValue
        ]
        
        let url = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1"
        
        AF.request(url, headers: headers).responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let profile):
                print("TODO")
            case .failure(let error):
                print(error)
            }
            //TODO
        }
    }
    
//    func deleteLike()  {
//        let headers: [String : String ] = [
//            NetworkConstants.acceptKey : NetworkConstants.acceptValue,
//            NetworkConstants.tokenKey : NetworkConstants.tokenValue,
//            "Content-Type" : "application/json"
//        ]
//        
//        let body: [String : Any] = [
//            "likes" : "9e472edf-ed51-4901-8cfc-8eb3f617519f"
//        ]
//        
//        
//        
//        let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1")!
//        var request = URLRequest(url: url)
//        
//        request.httpMethod = "DELETE"
//        request.httpBody = Data()
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body)
//        } catch {
//            print("Error serializing parameters: \(error)")
//            return
//        }
//        
//        request.allHTTPHeaderFields = headers
//        
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print(error)
//                return
//            }
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("JSON", json)
//                } catch {
//                    print("ERROR", error)
//                    return
//                }
//            }
//        }
//        
//        task.resume()
//    }
}
