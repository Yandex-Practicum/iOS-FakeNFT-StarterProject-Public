import Foundation

final class NftCollectionViewModel {
	
	// MARK: Public properties
	
	var nftsUrls: [String]?
	
	@Observable
	var nfts: [NftCollectionCellViewModel] = []
	
	// MARK: Private properties
	
	private var likes: [String] = []
	private var order: [String] = []
	
	// MARK: Public methods
	
	func getOrder() {
		let request = OrderRequest()
		let store = Store<Order>(request: request)
		
		store.sendRequest { [weak self] result in
			guard let self else {
				return
			}
			
			switch result {
			case .success(let data):
				self.order = data.nfts
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			self.getLikes()
		}
	}
	
	func setLiked(id: String, isLiked: Bool) {
		if isLiked {
			likes.append(id)
		} else if let index = likes.firstIndex(of: id) {
			likes.remove(at: index)
		}

		let request = PutLikesRequest(likes: likes)
		let store = Store<Likes>(request: request)

		store.sendRequest { [weak self] result in
			guard let self else {
				return
			}

			switch result {
			case .success(_):
				let cellViewModel = nfts.first { item in
					item.id == id
				}
				cellViewModel?.liked = isLiked
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
		}
	}
	
	func cart(id: String, isAdded: Bool) {
		if isAdded {
			order.append(id)
		} else if let index = order.firstIndex(of: id) {
			order.remove(at: index)
		}

		let request = PutOrderRequest(nfts: order)
		let store = Store<Order>(request: request)

		store.sendRequest { [weak self] result in
			guard let self else {
				return
			}

			switch result {
			case .success(_):
				let cellViewModel = nfts.first { item in
					item.id == id
				}
				cellViewModel?.ordered = isAdded
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
		}
	}
	
	// MARK: Private methods
	
	private func getNfts() {
		guard let nftsUrls else {
			return
		}
		
		for url in nftsUrls {
			getNft(id: url) { [weak self] result in
				guard let self else {
					return
				}
				
				switch result {
				case.success(let nft):
					nfts.append(
						NftCollectionCellViewModel(
							id: nft.id,
							iconUrl: nft.images.first ?? "",
							rating: nft.rating,
							name: nft.name,
							cost: nft.price,
							liked: likes.contains(nft.id),
							ordered: order.contains(nft.id)
						)
					)
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
			}
		}
	}
	
	private func getNft(
		id: String,
		completion: @escaping (Result<Nft, Error>) -> Void
	) {
		let request = NFTRequest(id: id)
		let store = Store<Nft>(request: request)
		
		store.sendRequest(completion: completion)
	}
	
	private func getLikes() {
		let request = LikesRequest()
		let store = Store<Likes>(request: request)
		
		store.sendRequest { [weak self] result in
			guard let self else {
				return
			}
			
			switch result {
			case .success(let data):
				self.likes = data.likes
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			self.getNfts()
		}
	}
}
