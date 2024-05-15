import UIKit

protocol CartPayPresenterProtocol {
    var visibleCurrencies: [Currencies] { get set }
    var view: CartPayViewControllerProtocol? { get set }
    func getCurrencies(completion: @escaping (Result<[Currencies], Error>) -> Void)
    func getPayAnswer(currencyId: String, completion: @escaping (Result<PayAnswer, Error>) -> Void)
}

final class CartPayPresenter: CartPayPresenterProtocol {

    weak var view: CartPayViewControllerProtocol?

    var visibleCurrencies: [Currencies] = []

    private let networkClient: DefaultNetworkClient

    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }

    func getCurrencies(completion: @escaping (Result<[Currencies], Error>) -> Void) {
        let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/currencies")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("9db803ac-6777-4dc6-9be2-d8eaa53129a9", forHTTPHeaderField: "X-Practicum-Mobile-Token")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            do {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                let currencies = try JSONDecoder().decode([Currencies].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(currencies))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    func getPayAnswer(currencyId: String, completion: @escaping (Result<PayAnswer, Error>) -> Void) {
        let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1/payment/\(currencyId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("9db803ac-6777-4dc6-9be2-d8eaa53129a9", forHTTPHeaderField: "X-Practicum-Mobile-Token")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            do {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                let answer = try JSONDecoder().decode(PayAnswer.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(answer))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    private func saveItems(items: [Currencies]) {
        visibleCurrencies = items
    }
}
