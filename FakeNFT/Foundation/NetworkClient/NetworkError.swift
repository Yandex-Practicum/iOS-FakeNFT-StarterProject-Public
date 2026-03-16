import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case transport(URLError)
    case server(statusCode: Int, body: String?)
    case noData
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный URL."
        case .transport(let e):
            switch e.code {
            case .notConnectedToInternet: return "Нет интернета."
            case .timedOut: return "Таймаут запроса."
            default: return "Сетевая ошибка: \(e.localizedDescription)"
            }
        case .server(let code, _):
            return "Ошибка сервера (\(code))."
        case .noData:
            return "Пустой ответ сервера."
        case .decoding:
            return "Не удалось разобрать ответ сервера."
        }
    }
}


extension NetworkClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .httpStatusCode(let code):
            return "Ошибка сервера (\(code))"
        case .urlRequestError(let error):
            return "Сетевая ошибка: \(error.localizedDescription)"
        case .urlSessionError:
            return "Нет ответа от сервера"
        case .parsingError:
            return "Не удалось обработать ответ"
        }
    }
}
