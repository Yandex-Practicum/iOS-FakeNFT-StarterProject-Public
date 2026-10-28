import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Свойства
    weak var view: ProfileViewProtocol?
    
    // Сетевой клиент
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - ProfilePresenterProtocol
    func viewDidLoad() {
        loadProfile()
    }
    
    func didTapMyNFTs() {
        print("Нажата кнопка Мои NFT")
    }
    
    func didTapFavorites() {
        print("Нажата кнопка Избранные NFT")
    }
    
    func didTapWebsite(urlString: String?) {
        print("Нажата ссылка на сайт: \(urlString ?? "нет ссылки")")
    }
    
    // MARK: - Private Methods
    private func loadProfile() {
        view?.showLoading()
        
        // СЕРВЕР НЕДОСТУПЕН
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.view?.hideLoading()
            
            let mockProfile = Profile(
                id: "1",
                name: "Ульяна",
                description: "Начинающий iOS-разработчик. Люблю писать чистый код и решать сложные задачи.",
                website: "https://github.com/lulu0llli",
                avatar: "https://i.pinimg.com/474x/c8/5f/ba/c85fba15f945ae1c8dd7e3dfe88ac40f.jpg?nii=t",
                nfts: [],
                likes: []
            )
            self?.view?.showProfile(mockProfile)
        }
    }
}
