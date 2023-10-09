//
//  StatisticsViewModel.swift
//  FakeNFT
//

import Foundation

protocol StatisticsViewModelProtocol: AnyObject {
    var dataChanged: (() -> Void)? { get set }
    var users: [User] { get set }
    func usersCount() -> Int
    func loadData()
    func sortUsersByName()
    func sortUsersByRating()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    var dataChanged: (() -> Void)?
    
    var users: [User] = [] {
        didSet {
            dataChanged?()
        }
    }
    
    func usersCount() -> Int {
        return users.count
    }
    
    func loadData() {
        guard let url = URL(string: "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/users") else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode([User].self, from: data)

                    DispatchQueue.main.async {
                        self?.users = users
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func sortUsersByName() {
        users.sort { $0.name < $1.name }
    }
    
    func sortUsersByRating() {
        users.sort {  Int($0.rating) ?? 0 < Int($1.rating) ?? 0 }
    }
}
