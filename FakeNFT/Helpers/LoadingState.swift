import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded(hasData: Bool)
    case error(Error)
}
