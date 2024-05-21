import Foundation

final class CartNetwork {
    private let networkClient: DefaultNetworkClient

    init() {
        self.networkClient = DefaultNetworkClient()
    }

    func getCart(completion: @escaping (Cart?) -> Void) {
        networkClient.send(request: CartRequest(), type: Cart.self) { result in
            switch result {
            case .success(let cart):
                DispatchQueue.main.async {
                    completion(cart)
                }
            case .failure(let error):
                print("Error fetching NFT collection: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func sendNewOrder(nftsIds: [String], completion: @escaping (Error?) -> Void) {
        let nftsString = nftsIds.joined(separator: ",")
        let bodyString = "nfts=\(nftsString)"
        guard let bodyData = bodyString.data(using: .utf8) else { return }

        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("9db803ac-6777-4dc6-9be2-d8eaa53129a9", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        if nftsIds.count != 0 {
            request.httpBody = bodyData
        }

        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
        task.resume()
    }
}
