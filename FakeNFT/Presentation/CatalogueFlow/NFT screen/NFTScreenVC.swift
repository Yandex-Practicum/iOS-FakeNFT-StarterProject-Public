//
//  NFTScreenVC.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

final class NFTScreenVC: UIViewController {
    lazy var NFTView: UIView = {
        let view = NFTScreenView()

        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.authorLink.delegate = self

        return view
    }()

    let gridGeometric = GridGeometric(
        cellCount: 3, leftInset: 16, rightInset: 16, cellSpacing: 10
    )

    override func loadView() {
        view = NFTView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }


    private func hideTabBar() {
        if let tabBarController = self.tabBarController {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut]) {
                tabBarController.tabBar.frame = CGRect(
                    x: tabBarController.tabBar.frame.origin.x,
                    y: UIScreen.main.bounds.height,
                    width: tabBarController.tabBar.frame.width,
                    height: tabBarController.tabBar.frame.height
                )
            }
        }

        navigationController?.navigationBar.tintColor = UIColor.NFTColor.black
    }

    private func showTabBar() {
        if let tabBarController = self.tabBarController {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
                tabBarController.tabBar.frame = CGRect(
                    x: tabBarController.tabBar.frame.origin.x,
                    y: UIScreen.main.bounds.height - tabBarController.tabBar.frame.height,
                    width: tabBarController.tabBar.frame.width,
                    height: tabBarController.tabBar.frame.height
                )
            }
        }
    }
}

extension NFTScreenVC: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        let webViewVC = WebViewVC()
        webViewVC.urlString = "https://practicum.yandex.ru"

        navigationController?.pushViewController(webViewVC, animated: true)
        return false
    }
}
