import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        // Сначала открой файл RequestConstants (он лежит рядом) и посмотри,
        // как выглядит переменная с базовым URL (например, RequestConstants.baseURL).
        // Если там уже есть /api/v1, то напиши просто: URL(string: "\(RequestConstants.baseURL)/profile/1")
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}
