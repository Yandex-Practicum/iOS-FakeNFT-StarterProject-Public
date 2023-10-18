import Foundation

final class HandlingErrorService {
    func handlingHTTPStatusCodeError(error: Error) -> String? {
        guard let error = error as? NetworkClientError else { return nil }
        
        switch error {
        case .httpStatusCode(let code):
            switch  code {
            case 404:
                return "По запросу ничего не найдено"
            case 409:
                return "Ошибка обновления ресурса"
            case 410:
                return "Запрошенный ресурс больше недоступен"
            case 500...526:
                return "Ошибка на стороне сервера"
            default:
                return "Не удалось получить данные"
            }
            
        case .parsingError:
            return "Не удалось конвертировать полученные данные"
        case .urlRequestError:
            return  "Ошибка выполнения запроса"
        case .urlSessionError:
            return "Проверьте интернет - соединение"
        }
    }
}
