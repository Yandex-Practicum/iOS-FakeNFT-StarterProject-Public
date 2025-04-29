import Foundation

extension URLSession {
    
    // MARK: - Static Properties
    static let decoder: JSONDecoder = .init()
    
    // MARK: - objectTask func
    func objectTask<T: Codable>(for request: URLRequest, completion: @escaping(Result<T,Error>) -> Void) -> URLSessionTask {
        UIBlockingProgressHUD.show()
        let decoder = URLSession.decoder
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                    UIBlockingProgressHUD.dismiss()
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("objectTask failure")
                completion(.failure(error))
            }
        }
        return task
    }
    
    // MARK: - data func
    func cartData(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("Error: \(NetworkError.httpStatusCode(statusCode))")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Error: \(NetworkError.urlRequestError(error))")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Error: \(NetworkError.urlSessionError)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}

// MARK: - enum NetworkError
enum NetworkCartError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
