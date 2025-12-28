import Foundation

protocol UsersService {
    func loadUsers(page: Int, size: Int, completion: @escaping (Result<[User], Error>) -> Void)
    func loadUser(id: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class UsersServiceImpl: UsersService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadUsers(page: Int = 0, size: Int = 20, completion: @escaping (Result<[User], Error>) -> Void) {
        let request = UsersRequest(page: page, size: size)
        
        print("📡 Отправляем запрос на загрузку пользователей...")
        
        networkClient.send(request: request, type: [User].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    print("✅ Успешно загружено \(users.count) пользователе")
                    completion(.success(users))
                case .failure(let error):
                    print("❌ Ошибка загрузки: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        let request = UserRequest(id: id)
        
        networkClient.send(request: request, type: User.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
