import Foundation

protocol StatisticFabricDelegate: AnyObject {
    func reloadData()
}

final class StatisticFabric {
    
    private var listOfLeaderboard: [LeaderBoardModel] = []
    weak var delegate: StatisticFabricDelegate?
    
    @discardableResult
    func getSortedLeaderboard() -> [LeaderBoardModel] {
        
        listOfLeaderboard = listOfLeaderboard.sorted {
            $0.countOfNft > $1.countOfNft
        }
        return listOfLeaderboard
    }
    
    func getCountOfLeaderboard() -> Int {
        
        listOfLeaderboard.count
    }
    
    func getUserFromLeaderboard(by index: Int) -> LeaderBoardModel {
        
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
    
    init(listOfLeaderboard: [LeaderBoardModel], delegate: StatisticFabricDelegate) {
        self.listOfLeaderboard = listOfLeaderboard
        self.delegate = delegate
        getSortedLeaderboard()
    }
    
    convenience init(delegate: StatisticFabricDelegate) {
        self.init(listOfLeaderboard: MockData.shared.leaderboardStatistic, delegate: delegate)
    }
}
