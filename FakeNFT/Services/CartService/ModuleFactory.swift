import UIKit

class ModuleFactory {
    let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func makeCurrencyModule() -> UIViewController {
        let currencyViewModel = CurrencyViewModel(servicesAssembly: servicesAssembly)
        let currencyViewController = CurrencyScreenViewController(viewModel: currencyViewModel)
        let navigationController = UINavigationController(rootViewController: currencyViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hidesBottomBarWhenPushed = true
        return navigationController
    }
}
