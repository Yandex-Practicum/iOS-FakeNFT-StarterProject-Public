//
//  UserListViewModel.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 29.07.2023.
//

import Foundation
import Combine

protocol UserListViewModel {
    func transform(input: AnyPublisher<UsetListViewControllerInput, Never>) -> AnyPublisher<UserListViewModelOutput, Never>
}

enum UserListViewModelOutput {
    case loading
    case success([User])
    case failure(Error)
    case tryToLoadDataAfterFail
}

final class UserListViewModelImpl: UserListViewModel {
    // MARK: - Dependencies
    private let userStatisticService: UserService

    // Private Properties
    private let output: PassthroughSubject<UserListViewModelOutput, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var users: [User] = []
    private var isFirstSessionLaunch = true

    init(userStatisticService: UserService) {
        self.userStatisticService = userStatisticService
    }

    func transform(input: AnyPublisher<UsetListViewControllerInput, Never>) -> AnyPublisher<UserListViewModelOutput, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                self.output.send(.loading)
                self.loadData()

            case .pullToRefresh:
                self.loadData()

            case .cellIsTap(let indexPath):
                self.cellTap(for: indexPath)
            }
        }
        .store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }

    private func loadData() {
        userStatisticService.fetchUserStatistics { [weak self] result in
            switch result {
            case .success(let newData):
                guard let self else { return }

                self.users = newData.sortByRank()
                self.output.send(.success(users))

            case .failure(let failure):
                self?.output.send(.failure(failure))
            }
        }
    }

    private func cellTap(for indexPath: IndexPath) {
        // TODO: -
    }
}
