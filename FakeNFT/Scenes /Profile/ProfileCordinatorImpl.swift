//
//  ProfileCordinatorImpl.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 21.03.2025.
//

import UIKit


final class ProfileCoordinatorImpl: ProfileCoordinator {
    
    private let navigationController: UINavigationController
    private let servicesAssembly: ServicesAssembly
    
    init(navigationController: UINavigationController, servicesAssembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.servicesAssembly = servicesAssembly
    }
    
    func initialScene() {
        let profileService = servicesAssembly.profileService
        let viewModel = ProfileViewModelImpl(profileService: profileService, coordinator: self)
        let viewController = ProfileViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func profileEditingScene(profile: Profile) {
        guard let viewController = navigationController.topViewController as? ProfileViewController else {
            return
        }
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        viewController.present(vc, animated: true)
    }
    
    func myNftsScene(nfts: [String]) {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func favouritesScene(likes: [String]) {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func webViewScene(url: URL) {
        let webViewViewController = WebViewViewController(url: url)
        webViewViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(webViewViewController, animated: true)
    }
}
