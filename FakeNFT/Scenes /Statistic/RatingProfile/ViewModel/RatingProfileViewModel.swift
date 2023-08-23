import Foundation

final class RatingProfileViewModel {

    @Observable
    private(set) var user: User?

    @Observable
    private(set) var isLoading: Bool = false

    @Observable
    private(set) var errorMessage: String?

    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol = UserNetworkService()) {
        self.userService = userService
    }

    func getUser(userId: Int) {
        isLoading = true

        userService.getUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}
