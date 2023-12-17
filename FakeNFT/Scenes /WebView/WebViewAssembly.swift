//
// Created by Андрей Парамонов on 17.12.2023.
//

import UIKit

public final class WebViewAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build(url: URL) -> UIViewController {
        let viewModel = WebViewViewModelImpl(url: url)
        return WebViewViewController(viewModel: viewModel)
    }
}
