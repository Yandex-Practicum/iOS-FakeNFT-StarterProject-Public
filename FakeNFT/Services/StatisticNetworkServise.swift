import Foundation


final class StatisticNetworkServise {
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private let url: String = RequestConstants.baseURL
    private let token: String = RequestConstants.token
    
    // MARK: - Public Methods
    func fetchUsers(completion: @escaping (Result<Users, Error>) -> Void) {
        guard let url = URL(string: "https://\(self.url)/api/v1/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode(Users.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(users))
                    }
                } catch let parsingError {
                    DispatchQueue.main.async {
                        completion(.failure(parsingError))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
}
