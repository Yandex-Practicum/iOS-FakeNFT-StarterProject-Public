import Foundation

protocol UserCardViewModelProtocol {
	var user: User { get }
}

final class UserCardViewModel: UserCardViewModelProtocol {
	let user: User
	
	init(user: User) {
		self.user = user
	}
}
