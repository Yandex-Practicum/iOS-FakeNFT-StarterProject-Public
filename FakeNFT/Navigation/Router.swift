//
//  Router.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

protocol Routable: AnyObject {
    func setupRootViewController(viewController: UIViewController)
    func presentViewController(_ viewController: UIViewController?, animated: Bool, presentationStyle: UIModalPresentationStyle)
    func dismissViewController(_ viewController: UIViewController?, animated: Bool, completion: (() -> Void)?)
    func dismissToRootViewController(animated: Bool, completion: (() -> Void)?)
    func addTabBarItem(_ tab: UIViewController?)
    
}

final class Router {
    weak var delegate: RouterDelegate? // делегат роутера (сейчас - SceneDelegate) для управления тем, какой контроллер сейчас отображается
    private var currentViewController: UIViewController? // контроллер, который сейчас отображается на экране
    
    init(routerDelegate: RouterDelegate) {
        delegate = routerDelegate
    }
}

extension Router: Routable {
    func setupRootViewController(viewController: UIViewController) {
        currentViewController = viewController
        delegate?.setupRootViewController(currentViewController)
    }
    
    func presentViewController(_ viewController: UIViewController?, animated: Bool, presentationStyle: UIModalPresentationStyle) {
        guard let viewController else { return }
        viewController.modalPresentationStyle = presentationStyle
        currentViewController?.present(viewController, animated: true)
        currentViewController = viewController
    }
    
    func dismissViewController(_ viewController: UIViewController?, animated: Bool, completion: (() -> Void)?) {
        guard let viewController = viewController else { return }
        self.currentViewController = viewController.presentingViewController
        viewController.dismiss(animated: animated, completion: completion)
    }
    
    func dismissToRootViewController(animated: Bool, completion: (() -> Void)?) {
        let rootViewController = delegate?.returnRootViewController()
        self.currentViewController = rootViewController
        delegate?.dismissAllPresentedViewControllers()
    }
    
    func addTabBarItem(_ tab: UIViewController?) {
        guard
            let tab,
            let rootViewController = currentViewController as? UITabBarController
        else { return }
        
        var viewControllers = rootViewController.viewControllers ?? []
        viewControllers.append(tab)
        rootViewController.setViewControllers(viewControllers, animated: false)
    }
    
    
}
