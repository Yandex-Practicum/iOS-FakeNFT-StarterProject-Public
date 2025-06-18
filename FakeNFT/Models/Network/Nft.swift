import SwiftUI

struct Nft: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let images: [String]
    let description: String
    let rating: Int
    let price: Double
    let author: String
    
    static var mock: Self {
           .init(
               id: "739e293c-1067-43e5-8f1d-4377e744ddde",
               name: "Christi Noel",
               images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
               description: "fringilla eam vim sonet faucibus impetus",
               rating: 2,
               price: 36.54,
               author: "https://condescending_almeida.fakenfts.org/"
           )
       }
   }
