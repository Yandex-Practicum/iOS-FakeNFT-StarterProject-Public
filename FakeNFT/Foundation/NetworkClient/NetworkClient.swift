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
        let onResponse: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        guard let urlRequest = create(request: request) else { return nil }

        // Debug: log outgoing request
        logRequest(urlRequest)

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }

            // Debug: log every response status and body (if present)
            logResponse(response, data: data)

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
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        return send(request: request, completionQueue: completionQueue) { result in
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
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue

        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        let dtoDictionary = request.dto?.asDictionary()
        var urlComponents = URLComponents(url: endpoint, resolvingAgainstBaseURL: false) ?? URLComponents()

        switch request.httpMethod {
        case .get:
            // GET: передаём параметры только в query, без тела запроса.
            var items = request.queryItems
            if let dtoDictionary {
                items.append(contentsOf: dtoDictionary.map { URLQueryItem(name: $0.key, value: $0.value) })
            }
            if !items.isEmpty {
                var existingItems = urlComponents.queryItems ?? []
                existingItems.append(contentsOf: items)
                urlComponents.queryItems = existingItems
            }
            if let updatedURL = urlComponents.url {
                urlRequest.url = updatedURL
            }
        default:
            if let dtoDictionary {
                // POST/PUT/...: тело кодируем как x-www-form-urlencoded.
                var bodyComponents = URLComponents()
                bodyComponents.queryItems = dtoDictionary.map { URLQueryItem(name: $0.key, value: $0.value) }
                urlRequest.httpBody = bodyComponents.query?.data(using: .utf8)
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        }

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

    private func logRequest(_ request: URLRequest) {
        let urlString = request.url?.absoluteString ?? "nil"
        let method = request.httpMethod ?? "nil"
        let headers = request.allHTTPHeaderFields ?? [:]
        let bodyString: String
        if let body = request.httpBody, let str = String(data: body, encoding: .utf8) {
            bodyString = str
        } else {
            bodyString = "nil"
        }

        print("[Network][Request] \(method) \(urlString)")
        print("[Network][Headers] \(headers)")
        print("[Network][Body] \(bodyString)")
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data?) {
        let urlString = response.url?.absoluteString ?? "nil"
        print("[Network][Response] \(response.statusCode) \(urlString)")
        if let data, let body = String(data: data, encoding: .utf8), !body.isEmpty {
            print("[Network][ResponseBody] \(body)")
        }
    }
}
