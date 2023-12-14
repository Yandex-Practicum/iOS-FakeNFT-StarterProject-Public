import UIKit

struct FavoritesNFTCellViewModel {
    let title: String
    let imageUrl: URL?
    let formattedRating: Int
    let formattedPrice: String
    
    init(nft: NFT) {
        self.title = nft.name
        self.imageUrl = URL(string: nft.images.first ?? "")
        self.formattedRating = Int(nft.rating)

        if let formattedPrice = NumberFormatter.defaultPriceFormatter.string(from: NSNumber(value: nft.price)) {
            self.formattedPrice = "\(formattedPrice) ETH"
        } else {
            self.formattedPrice = "N/A"
        }
    }
}
