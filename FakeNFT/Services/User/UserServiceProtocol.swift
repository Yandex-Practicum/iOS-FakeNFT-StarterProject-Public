
protocol UserServiceProtocol {
    func getUserList(onCompletion: @escaping (Result<[User], Error>) -> Void)
    func getUser(userId: Int, onCompletion: @escaping (Result<User, Error>) -> Void)
}
