import UIKit

final class NFTCollectionModuleBuilder {
  
    // MARK: - Properties
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Initialization
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Public Methods
    func build(with collection: Catalog) -> UIViewController {
        let viewController = NFTCollectionViewController(collection: collection)
        let router = NFTCollectionRouterImpl(
            viewController: viewController,
            servicesAssembly: servicesAssembly
        )
        let presenter = NFTCollectionPresenter(
            view: viewController,
            nftService: servicesAssembly.nftListService,
            favoriteService: servicesAssembly.favoriteNftService,
            orderService: servicesAssembly.orderNftService,
            router: router,
            nftIds: collection.nfts
        )

        viewController.output = presenter
        return viewController
    }
}

