//
//  UserNFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 02.05.2024.
//

import Foundation
import Alamofire

protocol UserNFTCollectionPresenterProtocol {
    var visibleNFT: [NFTModel] { get set }
    var nftsIDs: [String] { get set }
    func getNFT(complition: @escaping () -> Void )
}

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    
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
}
