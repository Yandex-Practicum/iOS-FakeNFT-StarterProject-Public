//
// Created by Андрей Парамонов on 17.12.2023.
//

import UIKit

public final class WebViewAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build(request: URLRequest) -> UIViewController {
        let viewModel = WebViewViewModelImpl(request: request)
        return WebViewViewController(viewModel: viewModel)
    }
}
