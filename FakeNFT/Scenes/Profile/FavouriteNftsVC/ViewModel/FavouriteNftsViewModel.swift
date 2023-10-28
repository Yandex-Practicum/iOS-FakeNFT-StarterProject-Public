import UIKit
import NotificationBannerSwift

final class FavouriteNftsViewModel: FavouriteNftsViewModelProtocol {
    // MARK: - Private Dependencies:
    private var dataProvider: ProfileDataProviderProtocol?

    // MARK: - Observable Values:
    var nftCardsObservable: Observable<NFTCards?> {
        $nftCards
    }

    var usersObservable: Observable<Users?> {
        $users
    }
    
    var profileObservable: Observable<Profile?> {
        $profile
    }
    
    @Observable
    private(set) var profile: Profile?
    
    var showErrorAlert: ((String) -> Void)?

    @Observable
    private(set) var nftCards: NFTCards?

    @Observable
    private(set) var users: Users?

    // MARK: - Lifecycle:
    init(dataProvider: ProfileDataProviderProtocol?) {
        self.dataProvider = dataProvider
        fetchUsers()
        fetchProfile()
    }

    // MARK: - Public Methods:
    func fetchNtfCards(likes: [String]) {
        dataProvider?.fetchUsersNFT(userId: nil, nftsId: likes) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nftCards):
                self.nftCards = nftCards
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self.showErrorAlert?(errorString ?? "")
            }
        }
    }
    
    func changeProfile(likesIds: [String]) {
        guard let profile = profile else { return }
        let newProfile = Profile(name: profile.name,
                                 avatar: profile.avatar,
                                 description: profile.description,
                                 website: profile.website,
                                 nfts: profile.nfts,
                                 likes: likesIds,
                                 id: profile.id)
        
        dataProvider?.changeProfile(profile: newProfile, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self.showErrorAlert?(errorString ?? "")
            }
        })
    }

    // MARK: - Private Methods:

    private func fetchUsers() {
        dataProvider?.fetchUsers { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self.showErrorAlert?(errorString ?? "")
            }
        }
    }
    
    private func fetchProfile() {
        dataProvider?.fetchProfile(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self.showErrorAlert?(errorString ?? "")
            }
        })
    }
}

