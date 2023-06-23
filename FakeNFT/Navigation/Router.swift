//
//  Router.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

protocol Routable: AnyObject {
    func setupRootViewController(viewController: Presentable)
    func presentViewController(_ viewController: Presentable?, animated: Bool, presentationStyle: UIModalPresentationStyle)
    func pushViewController(_ viewController: Presentable?, animated: Bool)
    func dismissViewController(_ viewController: Presentable?, animated: Bool, completion: (() -> Void)?)
    func dismissToRootViewController(animated: Bool, completion: (() -> Void)?)
    func popToRootViewController(animated: Bool, completion: (() -> Void)?)
    func addTabBarItem(_ tab: Presentable?)
    
}

final class Router {
    weak var delegate: RouterDelegate? // делегат роутера (сейчас - SceneDelegate) для управления тем, какой контроллер сейчас отображается
    private var currentViewController: UIViewController? // контроллер, который сейчас отображается на экране
    
    init(routerDelegate: RouterDelegate) {
        delegate = routerDelegate
    }
}

extension Router: Routable {
    func setupRootViewController(viewController: Presentable) {
        guard let vc = viewController.getVC() else { return }
        currentViewController = vc
        delegate?.setupRootViewController(currentViewController)
    }
    
    func presentViewController(_ viewController: Presentable?, animated: Bool, presentationStyle: UIModalPresentationStyle) {
        guard let vc = viewController?.getVC() else { return }
        vc.modalPresentationStyle = presentationStyle
        currentViewController?.present(vc, animated: true)
        currentViewController = vc
    }
    
    func pushViewController(_ viewController: Presentable?, animated: Bool) {
        guard let vc = viewController?.getVC(),
              let rootVC = delegate?.returnRootViewController() as? UITabBarController,
              let navController = rootVC.selectedViewController as? UINavigationController
        else { return }
        self.currentViewController = navController
        navController.pushViewController(vc, animated: animated)
    }
    
    func dismissViewController(_ viewController: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard let vc = viewController?.getVC() else { return }
        self.currentViewController = vc.presentingViewController
        vc.dismiss(animated: animated, completion: completion)
    }
    
    func dismissToRootViewController(animated: Bool, completion: (() -> Void)?) {
        let rootViewController = delegate?.returnRootViewController()
        self.currentViewController = rootViewController
        delegate?.dismissAllPresentedViewControllers()
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        guard let pushedVC = currentViewController as? UINavigationController else { return }
        pushedVC.popToRootViewController(animated: animated)
        self.currentViewController = delegate?.returnRootViewController()
    }
    
    func addTabBarItem(_ tab: Presentable?) {
        guard
            let tabVC = tab?.getVC(),
            let rootViewController = currentViewController as? UITabBarController
        else { return }
        
        var viewControllers = rootViewController.viewControllers ?? []
        viewControllers.append(tabVC)
        rootViewController.setViewControllers(viewControllers, animated: false)
    }
    
    
}
