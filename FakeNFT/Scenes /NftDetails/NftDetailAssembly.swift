import UIKit

public final class NftDetailAssembly {

    // MARK: - Private Properties
    
    private let servicesAssembler: ServicesAssembly
    
    // MARK: - Init

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    // MARK: - Public Methods

    public func build(with input: NftDetailInput) -> UIViewController {
        let presenter = NftDetailPresenterImpl(
            input: input,
            service: servicesAssembler.nftService
        )
        let viewController = NftDetailViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
