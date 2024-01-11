import UIKit

public final class NftDetailAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

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
