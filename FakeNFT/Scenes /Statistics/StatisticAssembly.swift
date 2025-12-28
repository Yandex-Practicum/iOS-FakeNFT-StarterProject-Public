
import UIKit

final class StatisticAssembly {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func assemble() -> StatisticViewController {
        let usersService = servicesAssembly.usersService
        let presenter = StatisticPresenter(usersService: usersService)
        let viewController = StatisticViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
