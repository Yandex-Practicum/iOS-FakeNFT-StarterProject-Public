import Foundation

enum Endpoint {
    static func getUsers() -> URL {
        URL(string: "https://64a03f83ed3c41bdd7a72309.mockapi.io/api/v1/users")!
    }

    static func getProfile(id: String) -> URL {
        URL(string: "https://64a03f83ed3c41bdd7a72309.mockapi.io/api/v1/users/\(id)")!
    }

    static func getNFT(id: String) -> URL {
        URL(string: "https://64a03f83ed3c41bdd7a72309.mockapi.io/api/v1/nft/\(id)")!
    }
}
