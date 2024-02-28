import Foundation

protocol StatisticsViewModelProtocol {
	var usersStore: UsersStore { get }
	var users: [StatisticsTableViewCellViewModel] { get }
	func getUsers()
	func sortBy(_ sortBy: SortBy)
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
	
	// MARK: Private Properties
	
	private let filterKey = "StatisticsViewFilter"
	
	@Observable
	private(set) var isLoading = false
	
	private var sortBy: SortBy? {
		get {
			guard let sortByString = UserDefaults.standard.string(forKey: filterKey),
				  let sortBy = SortBy(rawValue: sortByString) else {
				return .name
			}
			
			return sortBy
		}
		set {
			if let newValue {
				UserDefaults.standard.set(newValue.rawValue, forKey: filterKey)
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
		isLoading = true
		usersStore.getUsers(sortBy: self.sortBy) { [weak self] result in
			guard let self else {
				return
			}
			
			switch result {
			case.success(let users):
				self.users = users.map {
					StatisticsTableViewCellViewModel(user: $0)
				}
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			self.isLoading = false
		}
	}
	
	func sortBy(_ sortBy: SortBy) {
		self.sortBy = sortBy
	}
}
