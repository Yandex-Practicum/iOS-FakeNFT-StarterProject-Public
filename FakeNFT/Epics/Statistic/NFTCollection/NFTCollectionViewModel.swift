//
//  NFTCollectionViewModel.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 12.08.2023.
//

import Foundation
import Combine

protocol NFTCollectionViewModel {
    var nftViewModels: CurrentValueSubject<[NFTCellViewModel], Never> { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var isHiddenEmptyCollectionPlaceholder: CurrentValueSubject<Bool, Never> { get }
    var isErrorHidden: CurrentValueSubject<Bool, Never> { get }
    var isPulledToRefresh: Bool { get }

    func viewDidLoad()
    func pullToRefresh()
}

final class NFTCollectionViewModelImpl: NFTCollectionViewModel {
    let nftViewModels: CurrentValueSubject<[NFTCellViewModel], Never> = .init([])
    let isLoading: CurrentValueSubject<Bool, Never> = .init(true)
    let isHiddenEmptyCollectionPlaceholder: CurrentValueSubject<Bool, Never> = .init(true)
    let isErrorHidden: CurrentValueSubject<Bool, Never> = .init(true)

    private(set) var isPulledToRefresh = false
    private let nftsIdsToFetch: [Int]
    private let nftService: NFTSService
    private let likesService: LikesService
    private let orderService: StatisticsOrderService
    private var cancellables = Set<AnyCancellable>()

    init(
        nftsNumbers: [Int],
        nftService: NFTSService,
        likesService: LikesService,
        orderService: StatisticsOrderService
    ) {
        self.nftsIdsToFetch = nftsNumbers
        self.nftService = nftService
        self.likesService = likesService
        self.orderService = orderService
    }

    func viewDidLoad() {
        isLoading.send(true)
        getNFTWithLikesAndCartInfo()
    }

    func pullToRefresh() {
        isPulledToRefresh = true
        getNFTWithLikesAndCartInfo()
    }

    private func getNFTWithLikesAndCartInfo() {
        if nftsIdsToFetch.isEmpty {
            isHiddenEmptyCollectionPlaceholder.send(false)
            isLoading.send(false)
        } else {
            let combinedPublisher = Publishers.CombineLatest3(
                nftService.fetchNFTS(numbers: nftsIdsToFetch),
                likesService.fetchLikes(),
                orderService.fetchOrder()
            )

            combinedPublisher
                .timeout(20, scheduler: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard case .failure = completion else {
                        return
                    }

                    self?.isHiddenEmptyCollectionPlaceholder.send(true)
                    self?.isLoading.send(false)
                    self?.isErrorHidden.send(false)
                }, receiveValue: { [weak self] userNfts, myLikes, myOrder in
                    guard let self else { return }

                    let nftViewModels = self.configureLikesAndIfInCart(
                        userNfts: userNfts,
                        myLikes: myLikes,
                        myOrder: myOrder
                    )

                    self.isHiddenEmptyCollectionPlaceholder.send(nftViewModels.isEmpty ? false : true)
                    self.isLoading.send(false)
                    self.nftViewModels.send(nftViewModels)
                })
                .store(in: &cancellables)
        }
    }

    private func configureLikesAndIfInCart(
        userNfts: [NFT],
        myLikes: [Int],
        myOrder: [Int]
    ) -> [NFTCellViewModel] {
        var nfts = userNfts

        for (index, nft) in nfts.enumerated() {
            let id = Int(nft.id) ?? 0

            let isLiked = myLikes.contains { $0 == id }
            let isInCart = myOrder.contains { $0 == id }

            let updatedNFT = NFT(
                createdAt: nft.createdAt,
                name: nft.name,
                images: nft.images,
                rating: nft.rating,
                description: nft.description,
                price: nft.price,
                author: nft.author,
                id: nft.id,
                isInCart: isInCart,
                isLiked: isLiked
            )

            // заменяю нфт без лайка или пустой корзины на нфт с лайком или полной корзиной
            // делаю это что бы оставить модель не мутабельной ( без var )
            nfts[index] = updatedNFT
        }

        return nfts.map { NFTCellViewModel(nft: $0) }
    }
}
