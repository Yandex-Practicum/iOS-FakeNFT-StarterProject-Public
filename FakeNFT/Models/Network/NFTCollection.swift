import Foundation

struct NFTCollection: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    
    var coverURL: URL? {
        if let url = URL(string: cover), url.scheme != nil {
            return url
        }
        return URL(string: "\(RequestConstants.baseURL)\(cover)")
    }
    
    var nftCount: Int {
        nfts.count
    }
}
