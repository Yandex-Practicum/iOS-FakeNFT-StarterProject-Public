import Foundation

public protocol CartViewInteractorProtocol {
    func fetchOrder(with id: String,
                    onSuccess: @escaping LoadingCompletionBlock<CartViewModel.ViewState>,
                    onFailure: @escaping LoadingFailureCompletionBlock)
    func changeOrder(with id: String,
                     nftIds: [String],
                     onSuccess: @escaping LoadingCompletionBlock<CartViewModel.ViewState>,
                     onFailure: @escaping LoadingFailureCompletionBlock)
}

public final class CartViewInteractor {
    private var order: [NFTCartCellViewModel] = []
    private var accumulatedCost: Double = 0

    private let fetchingQueue = DispatchQueue.global(qos: .userInitiated)
    private let fetchingGroup = DispatchGroup()

    private let nftService: NFTNetworkCartService
    private let orderService: OrderServiceProtocol
    private let imageLoadingService: ImageLoadingServiceProtocol

    init(
        nftService: NFTNetworkCartService,
        orderService: OrderServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol
    ) {
        self.nftService = nftService
        self.orderService = orderService
        self.imageLoadingService = imageLoadingService
    }
}

// MARK: - CartViewInteractorProtocol
extension CartViewInteractor: CartViewInteractorProtocol {
    public func fetchOrder(
        with id: String,
        onSuccess: @escaping LoadingCompletionBlock<CartViewModel.ViewState>,
        onFailure: @escaping LoadingFailureCompletionBlock
    ) {
        self.orderService.fetchOrder(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                guard !order.nfts.isEmpty else {
                    onSuccess(.empty)
                    return
                }
                self.fetchNfts(ids: order.nfts, onSuccess: onSuccess, onFailure: onFailure)
            case .failure(let error):
                self.handleError(error: error, onFailure: onFailure)
            }
        }
    }

    public func changeOrder(
        with id: String,
        nftIds: [String],
        onSuccess: @escaping LoadingCompletionBlock<CartViewModel.ViewState>,
        onFailure: @escaping LoadingFailureCompletionBlock
    ) {
        self.orderService.changeOrder(id: id, nftIds: nftIds) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.fetchOrder(with: id, onSuccess: onSuccess, onFailure: onFailure)
            case .failure(let error):
                self.handleError(error: error, onFailure: onFailure)
            }
        }
    }
}

private extension CartViewInteractor {
    func fetchNfts(
        ids: [String],
        onSuccess: @escaping LoadingCompletionBlock<CartViewModel.ViewState>,
        onFailure: @escaping LoadingFailureCompletionBlock
    ) {
        ids.forEach { [weak self] nftId in
            guard let self = self else { return }

            self.fetchingGroup.enter()
            self.fetchNft(with: nftId, onFailure: onFailure) { [weak self] nft in
                guard let self = self else { return }
                self.accumulatedCost += nft.price
                self.order.append(nft)

                self.fetchingGroup.leave()
            }
        }

        self.fetchingGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            onSuccess(.loaded(self.order, self.accumulatedCost))
            self.order.removeAll()
            self.accumulatedCost = 0
        }
    }

    func fetchNft(
        with id: String,
        onFailure: @escaping LoadingFailureCompletionBlock,
        completion: @escaping LoadingCompletionBlock<NFTCartCellViewModel>
    ) {
        self.fetchingQueue.async { [weak self] in
            self?.nftService.getNFTItemBy(id: id) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.prepareNftWithImage(model: model, onFailure: onFailure, completion: completion)
                case .failure(let error):
                    self?.handleError(error: error, onFailure: onFailure)
                }
            }
        }
    }

    func prepareNftWithImage(
        model: NFTItemModel,
        onFailure: @escaping LoadingFailureCompletionBlock,
        completion: @escaping LoadingCompletionBlock<NFTCartCellViewModel>
    ) {
        let imageUrl = URL(string: model.images.first ?? "")
        self.imageLoadingService.fetchImage(url: imageUrl) { [weak self] result in
            switch result {
            case .success(let image):
                let nft = NFTCartCellViewModelFactory.makeNFTCartCellViewModel(
                    id: model.id,
                    name: model.name,
                    image: image,
                    rating: model.rating,
                    price: model.price
                )
                completion(nft)
            case .failure(let error):
                self?.handleError(error: error, onFailure: onFailure)
            }
        }
    }
}

private extension CartViewInteractor {
    func handleError(error: Error, onFailure: @escaping LoadingFailureCompletionBlock) {
        DispatchQueue.main.async {
            onFailure(error)
        }
    }
}
