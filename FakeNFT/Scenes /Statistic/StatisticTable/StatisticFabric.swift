import Foundation

protocol StatisticFabricDelegate: AnyObject {
    func reloadData()
    func showError(with error: Error)
}

final class StatisticFabric {
    
    var onNeedUpdate: (() -> Void)?
    
    private var listOfLeaderboard: [UsersModel] = []
    weak var delegate: StatisticFabricDelegate?
    private var usersService: UsersService
    
    private let dispatchGroup = DispatchGroup()
    
    init(
        delegate: StatisticFabricDelegate,
        servicesAssembly: ServicesAssembly
    ) {
        self.usersService = servicesAssembly.usersService
        self.delegate = delegate
        dispatchGroup.enter()
        self.setListOfLeaderboard()
        dispatchGroup.notify(queue: .main) {
            self.onNeedUpdate?()
        }
    }
    
    deinit {
        print("DEINIT")
    }
    
    func setListOfLeaderboard() {
        
        DispatchQueue.main.async {
            self.usersService.loadNft { [weak self] result in
                defer { self?.dispatchGroup.leave() }
                switch result {
                case .success(let users):
                    self?.listOfLeaderboard = users
                    self?.getSortedLeaderboard()
                case .failure(let error):
                    self?.delegate?.showError(with: error)
                    
                }
            }
        }
    }
    
    @discardableResult
    func getSortedLeaderboard() -> [UsersModel] {
        
        listOfLeaderboard = listOfLeaderboard.sorted {
            $0.getRating() > $1.getRating()
        }
        return listOfLeaderboard
    }
    
    func getCountOfLeaderboard() -> Int {
        
        listOfLeaderboard.count
    }
    
    func getUserFromLeaderboard(by index: Int) -> UsersModel {
        
        listOfLeaderboard[index]
    }
    
    func sortLeaderboardByName() {
        
        listOfLeaderboard = listOfLeaderboard.sorted {
            $0.name < $1.name
        }
        delegate?.reloadData()
    }
    
    func sortLeaderboardByRating() {
        
        getSortedLeaderboard()
        delegate?.reloadData()
    }
}
