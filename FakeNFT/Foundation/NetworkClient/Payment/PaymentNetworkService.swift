//
//  PaymentNetworkService.swift
//  FakeNFT
//
//  Created by Кирилл Дробин on 29.03.2025.
//

import Foundation

final class PaymentNetworkService {
    // MARK: - Singleton
    static let shared = PaymentNetworkService()
    private let storage = Storage.shared
    
    // MARK: - Private Properties
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private(set) var orderId = String()
    private init() {}
    
    private enum PaymentNetworkServiceError: Error {
        case paymentNetworkServiceError
    }
    
    // MARK: - Order Fetch
    func getOrder(_ completion: @escaping (Result<Order, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeRequest(string: HttpStrings.order.rawValue,
                                        httpMethod: HttpMethod.get.rawValue),
              task == nil
        else {
            print("Order request error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<Order, Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.orderId = data.id
                }
                
            case .failure(let error):
                print("responce error: \(error)")
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Currencies Fetch
    func getCurrencies(_ completion: @escaping (Result<[Currency], Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeRequest(string: HttpStrings.currencies.rawValue,
                                        httpMethod: HttpMethod.get.rawValue),
              task == nil
        else {
            print("Currencies request error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[Currency], Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.storage.forCurrenciesCollection = data
                }
                completion(.success(data))
            case .failure(let error):
                print("responce error: \(error)")
            }
        }
        self.task = task
        task.resume()
        
    }
    
    // MARK: - Before Pay
    func setCurrencyBeforePay(currencyID: String, _ completion: @escaping (Result<SetCurrency, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        guard let request = makeRequest(string: "\(HttpStrings.payment.rawValue)" + "\(currencyID)",
                                        httpMethod: HttpMethod.get.rawValue),
              task == nil
        else {
            print("setCurrency request error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<SetCurrency, Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case .success(let responce):
                completion(.success(responce))
                print("\(responce)")
            case .failure(let error):
                completion(.failure(error))
                print("responce error: \(error)")
            }
        }
        self.task = task
        task.resume()
        
    }
    
    // MARK: - Order Update/Pay
    func updateOrder(_ completion: @escaping (Result<Order, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        var nfts: [String] = []
        
        for i in storage.mockCartNfts {     // брать из данных для построения таблицы корзины
            nfts.append(i.id)
        }
        
        guard var request = makeRequest(string: HttpStrings.order.rawValue,
                                        httpMethod: HttpMethod.put.rawValue),
              task == nil
        else {
            return
        }
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var requestComponents = URLComponents()
        requestComponents.queryItems = [URLQueryItem(name: "nfts", value: arrayToStringConverter(nfts: nfts))]
        
        request.httpBody = requestComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<Order, Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case .success(let responce):
                DispatchQueue.main.async {
                    completion(.success(responce))
                }
            case .failure(let error):
                completion(.failure(error))
                print("responce error: \(error)")
            }
        }
        task.resume()
        return
    }
}

// MARK: - Private Methods
private func makeRequest(string: String, httpMethod: String) -> URLRequest? {
    guard let url = URL(
        string: string,
        relativeTo: URL(string: RequestConstants.baseURL)
    ) else {
        preconditionFailure("Unable to construct url")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
    return request
}

private func arrayToStringConverter(nfts: [String]) -> String {
    var dateStringArray = [String]()
    for i in nfts {
        dateStringArray.append(i)
    }
    return dateStringArray.joined(separator: ",")
}
