import Foundation

//extension URLSession {
//    func object<T: Decodable>(
//        for reguest: URLRequest,
//        comletion: @escaping (Result<T, Error>) -> Void
//    ) -> URLSessionTask? {
//        let decoder = JSONDecoder()
//        let task = URLSession.shared.data (for: reguest) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<T, Error> in
//                Result { try decoder.decode(T.self, from: data)}
//            }
//            comletion(response)
//        }
//        return task
//    }
//
//    enum NetworkError: Error {
//        case httpStatusCode(Int)
//        case urlRequestError(Error)
//        case urlSessionError
//    }
    
//    func data(
//        for request: URLRequest,
//        comletion: @escaping (Result<Data, Error>) -> Void
//    ) -> URLSessionTask {
//        let fulfillCompletion: (Result<Data, Error>) -> Void = {result in
//            DispatchQueue.main.async {
//                comletion(result)
//            }
//        }
//
//        let task = dataTask(with: request, completionHandler: {data, response, error in
//            if let data = data,
//               let response = response,
//               let statusCode = (response as? HTTPURLResponse)?.statusCode
//            {
//                if 200 ..< 300 ~= statusCode {
//                    fulfillCompletion(.success(data))
//                } else {
//                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
//                }
//            } else if let error = error {
//                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
//            } else {
//                fulfillCompletion(.failure(NetworkError.urlSessionError))
//            }
//        })
//        task.resume()
//        return task
//    }
//}
