import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
    case testError
}

protocol NetworkClient {
    @discardableResult
    func send(
        request: NetworkRequest,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask?

    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask?
}

struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    @discardableResult
    func send(request: NetworkRequest, onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        guard let urlRequest = create(request: request) else { return nil }

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }

            guard 200 ..< 300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }

            if let data = data {
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
    func send<T: Decodable>(request: NetworkRequest, type: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        return send(request: request) { result in
            switch result {
            case let .success(data):
                self.parse(data: data, type: type, onResponse: onResponse)
            case let .failure(error):
                onResponse(.failure(error))
            }
        }
    }

    // MARK: - Private

    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else { return nil }
        guard var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true) else { return nil }

        components.queryItems = request.queryParameters?.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        guard let url = components.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.body

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }

    private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            onResponse(.failure(NetworkClientError.parsingError))
        }
    }
}

struct StubNetworkClient: NetworkClient {
    
    private let decoder: JSONDecoder
    private let emulateError: Bool

    init(decoder: JSONDecoder = JSONDecoder(), emulateError: Bool) {
        self.decoder = decoder
        self.emulateError = emulateError
    }
    
    func send(request: FakeNFT.NetworkRequest, onResponse: @escaping (Result<Data, Error>) -> Void) -> FakeNFT.NetworkTask? {
        if emulateError {
            onResponse(.failure(NetworkClientError.testError))
        } else {
            onResponse(.success(expectedResponse))
        }
        
        return nil
    }
    
    func send<T>(request: FakeNFT.NetworkRequest, type: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) -> FakeNFT.NetworkTask? where T : Decodable {
        if emulateError {
            onResponse(.failure(NetworkClientError.testError))
        } else {
            self.parse(data: expectedResponse, type: type, onResponse: onResponse)
        }
        
        return nil
    }
    
    private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            onResponse(.failure(NetworkClientError.parsingError))
        }
    }
    
    private var expectedResponse: Data {
            """
            {
                "name": "Test Profile",
                "avatar": "",
                "description": "",
                "website": "",
                "nfts": ["1", "2", "3"],
                "likes": ["4", "5", "6"],
                "id": "1"
            }
""".data(using: .utf8) ?? Data()
        
    }
}
