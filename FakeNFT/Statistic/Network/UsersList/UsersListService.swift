//
//  UsersListService.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/19/25.
//
import Foundation

final class UsersListService {
    static let shared = UsersListService()
    static let didChangeNotification = Notification.Name(rawValue: "UsersListServiceDidChange")
    
    private(set) var users: [UsersListModel] = []
    private let size: Int = 10
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() {}
    
    private func makeUsersNextPageRequest(page: Int, size: Int) throws -> URLRequest? {
        guard let baseUrl = URL(string: RequestConstants.baseURL) else {
            throw UsersListServiceErrors.invalidURL
        }
        
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else {
            throw UsersListServiceErrors.invalidURL
        }
        
        components.path = "/api/v1/users"
        
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "sortBy", value: "\(SortStorage.shared.selectedSort?.rawValue ?? "name")")
        ]
        
        guard let url = components.url else {
            throw UsersListServiceErrors.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    func fetchUsersNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = (lastLoadedPage ?? -1) + 1
        
        guard let request = try? makeUsersNextPageRequest(page: nextPage, size: size) else {
            return
        }
        task?.cancel()
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[UsersListResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let response):
                let newUser = response.map { UsersListModel(result: $0)}
                DispatchQueue.main.async {
                    self.users.append(contentsOf: newUser)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: UsersListService.didChangeNotification, object: nil)
                }
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(UsersListServiceErrors.invalidFetchingUsersList) -  Error fetching users List, \(error.localizedDescription)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func deleteUsersList() {
        users = []
        lastLoadedPage = nil
    }
}
