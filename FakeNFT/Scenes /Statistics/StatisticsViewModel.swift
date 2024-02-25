import Foundation

protocol StatisticsViewModelProtocol {
	var usersStore: UsersStore { get }
	var users: [StatisticsTableViewCellViewModel] { get }
	func getUsers()
	func sortBy(_ sortBy: String)
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
	
	// MARK: Private Properties
	
	private let filterKey = "StatisticsViewFilter"
	
	private var sortBy: String? {
		get {
			UserDefaults.standard.string(forKey: filterKey)
		}
		set {
			if let newValue {
				UserDefaults.standard.set(newValue, forKey: filterKey)
			} else {
				UserDefaults.standard.set("", forKey: filterKey)
			}
			
			self.getUsers()
		}
	}
	
	private(set) var usersStore = UsersStore()
	
	@Observable
	private(set) var users: [StatisticsTableViewCellViewModel] = []
	
	// MARK: Public methods
	
	func getUsers() {
		UIBlockingProgressHUD.show()
		usersStore.getUsers(sortBy: self.sortBy) { result in
			switch result {
			case.success(let users):
				self.users = users.map {
					StatisticsTableViewCellViewModel(user: $0)
				}
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			UIBlockingProgressHUD.dismiss()
		}
	}
	
	func sortBy(_ sortBy: String) {
		self.sortBy = sortBy
	}
}
