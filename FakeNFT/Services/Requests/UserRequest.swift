//
// Created by Андрей Парамонов on 15.12.2023.
//

import Foundation

struct UserRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}
