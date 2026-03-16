import UIKit

enum SortType: Int {
    case name = 0
    case count = 1
}

final class CatalogPresenter {
    weak var view: CatalogViewInput?
    private let catalogProvider: CatalogProviderProtocol
    private let router: CatalogRouterInput
    
    private var catalog: [Catalog] = []
    
    private let sortTypeKey = "CatalogSortType"
    
    init(
        catalogProvider: CatalogProviderProtocol,
        router: CatalogRouterInput
    ) {
        self.catalogProvider = catalogProvider
        self.router = router
    }
    
    private func applySavedSorting() {
        guard let savedSortTypeRaw = UserDefaults.standard.object(forKey: sortTypeKey) as? Int,
              let savedSortType = SortType(rawValue: savedSortTypeRaw) else {
            return
        }
        
        switch savedSortType {
        case .name:
            sortByName()
        case .count:
            sortByCount()
        }
    }
}

// MARK: - CatalogViewOutput
extension CatalogPresenter: CatalogViewOutput {
    func viewDidLoad() {
        loadData()
        applySavedSorting()
    }
    
    func didTapSortByName() {
        sortByName()
        
        UserDefaults.standard.set(SortType.name.rawValue, forKey: sortTypeKey)
    }
    
    func didTapSortByCount() {
        sortByCount()
        
        UserDefaults.standard.set(SortType.count.rawValue, forKey: sortTypeKey)
    }
    
    private func sortByName() {
           catalog = catalog.sorted { $0.name < $1.name }
           view?.showCatalog(catalog)
       }
       
       private func sortByCount() {
           catalog = catalog.sorted { $0.nfts.count > $1.nfts.count }
           view?.showCatalog(catalog)
       }
    
    func didSelectItem(at index: Int) {
        let item = catalog[index]
        router.openCollection(item)
    }
}


// MARK: - Private Methods
private extension CatalogPresenter {
    
    func loadData() {
        view?.setLoading(true)
        catalogProvider.loadCatalog { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.view?.setLoading(false)
                switch result {
                case .success(let catalogData):
                    self.catalog = catalogData
                    self.view?.showCatalog(catalogData)
                case .failure(let error):
                    self.view?.showError(error)
                }
            }
        }
    }
}

// MARK: - Catalog Router
final class CatalogRouter: CatalogRouterInput {
    weak var viewController: UIViewController?
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func openCollection(_ collection: Catalog) {
        let builder = NFTCollectionModuleBuilder(servicesAssembly: servicesAssembly)
        let collectionVC = builder.build(with: collection)
        viewController?.navigationController?.pushViewController(collectionVC, animated: true)
    }
}

// MARK: - Catalog Assembly
final class CatalogAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let router = CatalogRouter(servicesAssembly: servicesAssembly)
        let presenter = CatalogPresenter(
            catalogProvider: servicesAssembly.catalogProvider,
            router: router
        )
        let viewController = CatalogViewController(output: presenter)
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}


