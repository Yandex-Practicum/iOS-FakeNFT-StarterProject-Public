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
    var error: PassthroughSubject<(), Never> { get }
    var isPulledToRefresh: Bool { get }

    func viewDidLoad()
    func pullToRefresh()
}

final class NFTCollectionViewModelImpl: NFTCollectionViewModel {
    var nftViewModels: CurrentValueSubject<[NFTCellViewModel], Never> = .init([])
    var isLoading: CurrentValueSubject<Bool, Never> = .init(true)
    var error: PassthroughSubject<(), Never> = .init()

    private(set) var isPulledToRefresh = false
    private let nftsIdsToFetch: [Int]
    private let nftService: NFTSService
    private let likesService: LikesService
    private let orderService: OrderService
    private var cancellables = Set<AnyCancellable>()

    init(
        nftsNumbers: [Int],
        nftService: NFTSService,
        likesService: LikesService,
        orderService: OrderService
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
        let combinedPublisher = Publishers.CombineLatest3(
            nftService.fetchNFTS(numbers: nftsIdsToFetch),
            likesService.fetchLikes(),
            orderService.fetchOrder()
        )

        combinedPublisher
            .sink(receiveCompletion: { [weak self] completion in
                guard case .failure = completion else {
                    return
                }

                self?.isLoading.send(false)
                self?.error.send()
            }, receiveValue: { [weak self] userNfts, myLikes, myOrder in
                guard let self else { return }

                let nftViewModels = self.configureLikesAndIfInCart(
                    userNfts: userNfts,
                    myLikes: myLikes,
                    myOrder: myOrder
                )

                self.isLoading.send(false)
                self.nftViewModels.send(nftViewModels)
            })
            .store(in: &cancellables)
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
