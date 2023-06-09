//
//  NFTViewModel.swift
//  FakeNFT
//

import Foundation

enum SortingMethod {
    case price, rating, name
}

final class NFTsViewModel: ViewModelProtocol {

    weak var profileViewModel: ProfileViewModelProtocol?

    private let nftIDs: [Int]
    private let nftStore: NFTStoreProtocol
    private var receivedNFTModels: [NFTModel] = []

    @Observable
    private(set) var nftViewModels: [NFTViewModel] = []

    @Observable
    private var isNFTsDownloadingNow: Bool = false

    @Observable
    private var nftsReceivingError: String = ""

    init(for nftsIDs: [Int], nftStore: NFTStoreProtocol = NFTStore()) {
        self.nftIDs = nftsIDs
        self.nftStore = nftStore
    }

    convenience init(for nftsIDs: [Int], profileViewModel: ProfileViewModelProtocol) {
        self.init(for: nftsIDs, nftStore: NFTStore())
        self.profileViewModel = profileViewModel

    }

    private func setNFTsViewModel(from nftModel: NFTModel) {
        receivedNFTModels.append(nftModel)
        if receivedNFTModels.count == nftIDs.count {
            isNFTsDownloadingNow = false
            nftViewModels = receivedNFTModels.map {
                NFTViewModel(name: $0.name,
                             image: URL(string: $0.images.first ?? ""),
                             rating: $0.rating,
                             author: Constants.mockAuthorString,
                             price: String($0.price).replacingOccurrences(of: ".", with: ",") + Constants.mockCurrencyString,
                             id: $0.id)
            }
        }
    }

    private func handle(_ error: Error) {
        isNFTsDownloadingNow = false
        nftsReceivingError = String(format: NSLocalizedString("nftsReceivingError", comment: "Message when receiving error while NFTs data downloading"), error as CVarArg)
    }
}

// MARK: - NFTsViewModelProtocol

extension NFTsViewModel: NFTsViewModelProtocol {

    var myNFTsTitle: String { String(NSLocalizedString("myNFTs", comment: "My NFT screen title")) }

    var favoritesNFTsTitle: String { NSLocalizedString("favoritesNFT", comment: "Favorites NFT screen title") }

    var nftViewModelsObservable: Observable<[NFTViewModel]> { $nftViewModels }

    var isNFTsDownloadingNowObservable: Observable<Bool> { $isNFTsDownloadingNow }

    var nftsReceivingErrorObservable: Observable<String> { $nftsReceivingError }

    var stubLabelIsHidden: Bool { !nftIDs.isEmpty }

    func nftViewDidLoad() {
        if nftIDs.isEmpty { return }
        isNFTsDownloadingNow = true
        receivedNFTModels = []
        nftStore.getNFTs(using: nftIDs) { [weak self] result in
            switch result {
            case .success(let nftModel): self?.setNFTsViewModel(from: nftModel)
            case .failure(let error): self?.handle(error)
            }
        }
    }

    func myNFTSorted(by sortingMethod: SortingMethod) {
        switch sortingMethod {
        case .price: nftViewModels.sort { Float($0.price.dropLast(4).replacingOccurrences(of: ",", with: ".")) ?? 0
            < Float($1.price.dropLast(4).replacingOccurrences(of: ",", with: ".")) ?? 0 }
        case .rating: nftViewModels.sort { $0.rating > $1.rating }
        case .name: nftViewModels.sort { $0.name < $1.name }
        }
    }

    func didTapLike(nft: Int, callback: @escaping () -> Void) {
        nftViewModels.remove(at: nft)
        var updatedLikes: [Int] = []
        nftViewModels.forEach { updatedLikes.append(Int($0.id) ?? 0) }
        profileViewModel?.didChangeProfile(name: nil,
                                           description: nil,
                                           website: nil,
                                           avatar: nil,
                                           likes: updatedLikes,
                                           viewCallback: callback)
    }
}
