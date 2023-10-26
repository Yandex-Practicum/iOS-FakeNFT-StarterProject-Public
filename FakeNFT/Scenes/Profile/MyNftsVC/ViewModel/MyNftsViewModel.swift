import UIKit

final class MyNFTViewModel: MyNFTViewModelProtocol {

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
    
    var showErrorAlert: ((String) -> Void)?
    
    @Observable
    private(set) var profile: Profile?

    @Observable
    private(set) var nftCards: NFTCards?

    @Observable
    private(set) var users: Users?
    
    private var currentSortOption: SortingOption? {
        didSet {
            guard let currentSortOption else { return }
            sortStorage.saveSorting(currentSortOption)
        }
    }
    private let sortStorage: MyNftSortStorageProtocol

    // MARK: - Lifecycle:
    init(dataProvider: ProfileDataProviderProtocol?) {
        self.dataProvider = dataProvider
        sortStorage = MyNftSortStorage()
        currentSortOption = sortStorage.fetchSorting()
        fetchUsers()
        fetchProfile()
    }

    // MARK: - Public Methods:
    func fetchNtfCards(nftIds: [String]) {
        dataProvider?.fetchUsersNFT(userId: nil, nftsId: nftIds) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nftCards):
                self.nftCards = nftCards
                if let currentSortOption = self.currentSortOption {
                    self.sortNFTCollection(option: currentSortOption)
                }
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self.showErrorAlert?(errorString ?? "")
            }
        }
    }

    func sortNFTCollection(option: SortingOption) {
        guard let nftCards else { return }

        var cards = [NFTCard]()

        switch option {
        case .byPrice:
            cards = nftCards.sorted(by: { $0.price > $1.price })
        case .byRating:
            cards = nftCards.sorted { nft1, nft2 in
                nft1.rating > nft2.rating
            }
        case .byName:
            cards = nftCards.sorted { nft1, nft2 in
                nft1.name < nft2.name
            }
        case .close:
            cards = nftCards
        default:
            break
        }

        self.nftCards = cards
        currentSortOption = option
    }
    
    func changeProfile(likesIds: [String]) {
        guard let profile else { return }
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
        dataProvider?.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self.showErrorAlert?(errorString ?? "")
            }
        }
    }
}
