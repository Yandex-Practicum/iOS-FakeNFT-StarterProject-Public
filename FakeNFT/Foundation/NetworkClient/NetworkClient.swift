import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

protocol NetworkClient {
    @discardableResult
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?

    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            completionQueue: DispatchQueue,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
}

extension NetworkClient {

    @discardableResult
    func send(request: NetworkRequest,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        send(request: request, completionQueue: .main, onResponse: onResponse)
    }

    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
    }
}

struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        print("GO TO NEXT SEND ON NETWORK CLIENT")
        let onResponse: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                print("IN ????")
                onResponse(result)
            }
        }
        guard let urlRequest = create(request: request) else { return nil }
        print("AFTER CREATING REQUEST AND BEFORE CLOSURE + \(Date())")
        let task = session.dataTask(with: urlRequest) { data, response, error in
            print("START CLOSURE BEFORE PARSE + \(Date())")
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }

            guard 200 ..< 300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }

            if let data = data {
                print("GO START PARSE")
                onResponse(.success(data))
                return
            } else if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            } else {
                assertionFailure("Unexpected condition!")
                return
            }
        }

        task.resume()

        return DefaultNetworkTask(dataTask: task)
    }

    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        print("SEND ON NETWORK CLIENT")
        return send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case let .success(data):
                print("GO TO PARSE")
                DispatchQueue.global(qos: .userInitiated).sync {
                    self.parse(data: data, type: type, onResponse: onResponse)
                }
            case let .failure(error):
                onResponse(.failure(error))
            }
        }
    }

    // MARK: - Private

    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }
        print("CREATE REQUEST")
//        let kek = "KEKW"
//        if let kekEncoded = try? encoder.encode(kek) {
//            print("I LIKE COCKS")
//        } else {
//            print("I'M DON'T LIKE COCKS =(")
//        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue

        if let dto = request.dto,
           let dtoEncoded = try? encoder.encode(dto) {
            urlRequest
                .setValue("application/json",
                          forHTTPHeaderField: "Accept")
            urlRequest.httpBody = dtoEncoded
        }
        
        if let putHeader = request.putHeader {
            urlRequest
                .setValue(putHeader, forHTTPHeaderField: "Content-Type")
        }
        let token = "107f0274-8faf-4343-b31f-c12b62673e2f"
        urlRequest
            .setValue("\(token)",
                      forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return urlRequest
    }

    private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            print("COMPLETE PARSE")
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            print(error)
            onResponse(.failure(NetworkClientError.parsingError))
        }
    }
}
