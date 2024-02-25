import Foundation

final class UsersStore {
	let networkClient = DefaultNetworkClient()
	
	func getUsers(
		sortBy: String? = nil,
		completion: @escaping (Result<[User], Error>) -> Void
	) {
		let request = UsersRequest(sortBy: sortBy)
		
		networkClient.send(
			request: request,
			type: [User].self,
			completionQueue: DispatchQueue.main,
			onResponse: completion
		)
	}
}
