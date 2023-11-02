import UIKit

final class StatisticsViewModel {
    enum SortType {
        case name
        case rating
    }

    @Observable
    var userModels: [UserModel] = []

    @Observable
    var isLoading: Bool = false

    private let model: StatisticsLoader
    private let router: StatisticsNavigation
    private var sorting: SortType = .rating {
        didSet {
            userModels = applySort(sorting, to: userModels)
        }
    }

    init(model: StatisticsLoader, router: StatisticsNavigation) {
        self.model = model
        self.router = router
    }

    func loadData() {
        isLoading = true
        model.loadUsers { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                self.isLoading = false

                switch result {
                case let .success(models):
                    let viewModelModels = models.map(UserModel.init(serverModel:))
                    self.userModels = self.applySort(self.sorting, to: viewModelModels)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }

    func didSelectItem(indexPath: IndexPath) {
        router.goToProfile(userID: userModels[indexPath.row].id)
    }

    func didSelectSort(_ sort: SortType) {
        sorting = sort
    }

    private func applySort(_ sort: SortType, to models: [UserModel]) -> [UserModel] {
        models.sorted { first, second in
            switch sort {
            case .name:
                return first.name < second.name
            case .rating:
                return first.rating < second.rating
            }
        }
    }
}
