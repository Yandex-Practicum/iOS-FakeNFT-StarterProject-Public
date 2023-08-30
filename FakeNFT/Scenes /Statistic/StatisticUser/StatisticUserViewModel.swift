import Foundation

final class StatisticUserViewModel {
    // MARK: - Private Properties
    private(set) var profile: UserResponse
    
    // MARK: - Init
    init(profile: UserResponse ) {
      self.profile = profile
    }
}
