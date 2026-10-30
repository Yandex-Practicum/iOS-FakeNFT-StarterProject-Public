import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Свойства
    weak var view: ProfileViewProtocol?
    
    // Сетевой клиент
    private let networkClient: NetworkClient
    
    // Храним текущий профиль, чтобы передать его на экран редактирования
    private var currentProfile: Profile?
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - ProfilePresenterProtocol
    func viewDidLoad() {
        loadProfile()
    }
    
    func didTapMyNFTs() {
        view?.navigateToMyNFTs()
    }
    
    func didTapFavorites() {
        view?.navigateToFavorites()
    }
    
    func didTapWebsite(urlString: String?) {
        print("Нажата ссылка на сайт: \(urlString ?? "нет ссылки")")
    }
    
    func updateProfile(with newProfile: Profile) {
        self.currentProfile = newProfile
        view?.showProfile(newProfile)
    }
    
    // Метод для нажатия на карандаш
    func didTapEdit() {
        guard let profile = currentProfile else { return }
        view?.showEditScreen(with: profile)
    }
    
    // MARK: - Private Methods
    private func loadProfile() {
        view?.showLoading()
        
        // СЕРВЕР НЕДОСТУПЕН (используем мок)
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
            
            // Сохраняем профиль в свойство, чтобы работал didTapEdit
            self?.currentProfile = mockProfile
            
            // Отображаем профиль на экране
            self?.view?.showProfile(mockProfile)
        }
    }
}
