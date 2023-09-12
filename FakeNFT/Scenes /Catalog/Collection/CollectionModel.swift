import UIKit

struct User {
    let name: String
    let website: String
    let id: String
    
    init(with user: UserNetworkModel) {
        self.name = user.name
        self.website = user.website
        self.id = user.id
    }
}


struct Order {
    let nfts: [String]
    let id: String
    
    init(with nft: OrderModel) {
        self.nfts = nft.nfts
        self.id = nft.id
    }
}
