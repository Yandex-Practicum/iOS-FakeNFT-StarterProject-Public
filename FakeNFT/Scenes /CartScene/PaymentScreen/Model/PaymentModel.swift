//
//  PaymentModel.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 27.06.2023.
//

import Foundation

protocol PaymentModelProtocol {
    
    func getСurrencies(completion: @escaping ([PaymentStruct]) -> Void)
    
}

final class PaymentModel: PaymentModelProtocol {
    
    var urlString = "https://64858e8ba795d24810b71189.mockapi.io/api/v1/currencies"
    
    func getСurrencies(completion: @escaping ([PaymentStruct]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([PaymentStruct].self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Ошибка загрузки данных корзины \(error)")
                }
            }
        }).resume()
    }
    
}
