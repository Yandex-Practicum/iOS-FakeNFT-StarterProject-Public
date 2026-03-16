import Foundation

struct PageDto: Dto {
    let page: Int
    let size: Int
    let sortBy: String?

    func asDictionary() -> [String : String] {
        var dict: [String: String] = [
            "page": String(page),
            "size": String(size)
        ]
        if let sortBy { dict["sortBy"] = sortBy }
        return dict
    }
}

