import Foundation

struct Nft: Decodable {
	let id: String
	let name: String
	let images: [String]
	let rating: Int
	let price: Float
}
