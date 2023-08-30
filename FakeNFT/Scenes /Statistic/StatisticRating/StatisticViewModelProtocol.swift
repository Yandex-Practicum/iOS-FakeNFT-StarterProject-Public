import Foundation

protocol StatisticViewModelProtocol {
    var usersRatingObservable: Observable<UsersResponse> { get }
    var networkErrorObservable: Observable<String?> { get }
    
    func sortUsers(by type: SortingOption, usersList: UsersResponse)
    func saveSortingOption()
    func fetchUsersRating()
}
