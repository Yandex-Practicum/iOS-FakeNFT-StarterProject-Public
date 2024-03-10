import Foundation

final class Store<ResponseType: Decodable> {
	let networkClient = DefaultNetworkClient()
	let request: NetworkRequest
	
	func sendRequest(
		completion: @escaping (Result<ResponseType, Error>) -> Void
	) {
		networkClient.send(
			request: request,
			type: ResponseType.self,
			completionQueue: DispatchQueue.main,
			onResponse: completion
		)
	}
	
	init(request: NetworkRequest) {
		self.request = request
	}
}
