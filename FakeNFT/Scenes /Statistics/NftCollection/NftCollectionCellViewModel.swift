import Foundation

final class NftCollectionCellViewModel {
	
	// MARK: Public properties
	
	let id: String
	let iconUrl: String
	let rating: Int
	let name: String
	let cost: Float
	
	@Observable
	var liked: Bool
	
	@Observable
	var ordered: Bool
	
	// MARK: Lifecycle
	
	init(
		id: String,
		iconUrl: String,
		rating: Int,
		name: String,
		cost: Float,
		liked: Bool,
		ordered: Bool
	) {
		self.id = id
		self.iconUrl = iconUrl
		self.rating = rating
		self.name = name
		self.cost = cost
		self.liked = liked
		self.ordered = ordered
	}
}
