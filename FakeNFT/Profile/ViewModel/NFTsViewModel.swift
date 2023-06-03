//
//  NFTViewModel.swift
//  FakeNFT
//

// КОММЕНТАРИЙ ДЛЯ РЕВЬЮЕРА
// Что НЕ сделано:
// 1. На экране Мои NFT не отображается автор NFT. Пока что не могу по-нормальному это реализовать. API изначально отдаёт NFT без автора. Чтобы добыть автора надо: взять все коллекции NFT, по ID NFT найти там ID автора, потом по ID автора получить имя автора. Учитывая, что ответы на все эти запросы приходят асинхронно, я пока что не смог осилить эту задачу. Но продолжаю попытки)
// 2. Не реализована сортировка Моих NFT. Проблем нет, сделаю, нехватка времени.
// 3. Не реализованы заглушеи на случай отсутствия Моих или Избранных NFT. Проблем нет, сделаю, нехватка времени.
// 4. Не реализован WebView О разработчике. Проблем нет, сделаю, нехватка времени.

import Foundation

final class NFTsViewModel {

    private var nftStore: NFTStoreProtocol?
    private var nfts: [Int] = []
    private var receivedNFTModels: [NFTModel] = []
    private var receivedAuthorModels: [AuthorModel] = []
    private var authorsCount = 0
    private var temporaryAuthorViewModels: [AuthorViewModel] = []

    @Observable
    private(set) var nftViewModels: [NFTViewModel] = []
    @Observable
    private var isNFTsDownloadingNow: Bool = false
    @Observable
    private var authorViewModels: [AuthorViewModel] = []

    init(nftStore: NFTStoreProtocol = NFTStore()) {
        self.nftStore = nftStore
        self.nftStore?.delegate = self
    }
}

extension NFTsViewModel: NFTsViewModelProtocol {

    var nftViewModelsObservable: Observable<[NFTViewModel]> { $nftViewModels }
    var isNFTsDownloadingNowObservable: Observable<Bool> { $isNFTsDownloadingNow }
    var authorsObservable: Observable<[AuthorViewModel]> { $authorViewModels }

    func get(_ nfts: [Int]) {
        nftStore?.get(nfts)
        self.nfts = nfts
        isNFTsDownloadingNow = true
    }

    func getAuthors() {
        nftStore?.getСollections()
    }
}

// MARK: - NFTStoreDelegate

extension NFTsViewModel: NFTStoreDelegate {

    func didReceive(_ nftModel: NFTModel) {
        receivedNFTModels.append(nftModel)
        if receivedNFTModels.count == nfts.count {
            isNFTsDownloadingNow = false
            nftViewModels = receivedNFTModels.map {
                NFTViewModel(name: $0.name,
                             image: URL(string: $0.images.first ?? ""),
                             rating: $0.rating.ratingString,
                             price: String($0.price).replacingOccurrences(of: ".", with: ",") + Constants.ethCurrency,
                             id: $0.id)
            }.sorted { Int($0.id) ?? 0 < Int($1.id) ?? 0 }
        }
    }

    func didReceive(_ nftCollections: [CollectionModel]) {
        for nft in nfts {
            let collection = nftCollections.first { $0.nfts.contains(nft) }
            temporaryAuthorViewModels.append(AuthorViewModel(id: String(collection?.author ?? 0),
                                                             name: "",
                                                             nftID: String(nft)))
        }
        nftStore?.getNames(for: temporaryAuthorViewModels)
        authorsCount = temporaryAuthorViewModels.count
    }

    func didReceive(_ userModel: AuthorModel) {
//        receivedAuthorModels.append(userModel)
//        if receivedAuthorModels.count == authorsCount {
//            temporaryAuthorViewModels.map { viewModel in
//                viewModel.name = receivedAuthorModels.first { $0.id == viewModel.id }?.name
//            }
//
//
//            authorViewModels = receivedAuthorModels.map {
//                AuthorViewModel(
//                    name: $0.name,
//                    nftID: String(authorIDs[Int($0.id) ?? 0] ?? 0))
//            }
//        }
    }
}
