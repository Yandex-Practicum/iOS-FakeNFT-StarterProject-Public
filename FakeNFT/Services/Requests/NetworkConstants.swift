import Foundation

 enum NetworkConstants {
    enum HTTPMethod {
        static let get = "GET"
        static let put = "PUT"
        static let post = "POST"
        static let delete = "DELETE"
    }
    
    enum Headers {
        static let accept = "Accept"
        static let contentType = "Content-Type"
        static let token = "X-Practicum-Mobile-Token"
    }
    
    enum ContentType {
        static let json = "application/json"
        static let formUrlEncoded = "application/x-www-form-urlencoded"
        static let multipartFormData = "multipart/form-data"
    }
    
    enum RequestConstants {
        static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
        static let token = "aa87dab8-01e5-4aa8-957e-951e3edcb363"
    }
     static let defaultTimeout: TimeInterval = 30
}
