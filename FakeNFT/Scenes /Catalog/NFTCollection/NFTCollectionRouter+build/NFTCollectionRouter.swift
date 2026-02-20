import UIKit

final class NFTCollectionRouterImpl: NFTCollectionRouter {
    
    // MARK: - Properties
    private weak var viewController: UIViewController?
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Initialization
    init(viewController: UIViewController, servicesAssembly: ServicesAssembly) {
        self.viewController = viewController
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - NFTCollectionRouter
    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showNftDetail(id: String) {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let input = NftDetailInput(id: id)
        let detailsVC = assembly.build(with: input)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

