import Foundation

protocol StatisticFabricDelegate: AnyObject {
    func reloadData()
    func showError(with error: Error)
}

final class StatisticFabric {
    
    private var listOfLeaderboard: [UsersModel] = []
    weak var delegate: StatisticFabricDelegate?
    private var usersService: UsersService
    
    init(
        delegate: StatisticFabricDelegate,
        servicesAssembly: ServicesAssembly
    ) {
        self.usersService = servicesAssembly.usersService
        self.delegate = delegate
        DispatchQueue.global(qos: .userInitiated).sync {
            setListOfLeaderboard()
        }
    }
    
    deinit {
        print("DEINIT")
    }
    
    func setListOfLeaderboard() {
        
        usersService.loadNft { [weak self] result in
            switch result {
            case .success(let users):
                self?.listOfLeaderboard = users
                self?.getSortedLeaderboard()
            case .failure(let error):
                self?.delegate?.showError(with: error)
                
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
