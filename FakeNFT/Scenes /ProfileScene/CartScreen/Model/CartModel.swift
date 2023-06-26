//
//  CartModel.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 25.06.2023.
//

import Foundation

protocol CartModelProtocol {
    
    func getNFT(nftID: String, completion: @escaping (CartStruct) -> Void)
    
}

final class CartModel: CartModelProtocol {
    
    var urlString = "https://64858e8ba795d24810b71189.mockapi.io/api/v1/nft/"
    
    func getNFT(nftID: String, completion: @escaping (CartStruct) -> Void) {
        let requestString = urlString + nftID
        guard let url = URL(string: requestString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(CartStruct.self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Ошибка загрузки данных корзины \(error) \(nftID)")
                }
            }
        }).resume()
    }
    
}
