//
//  UIViewController + Ext loadingAnimation.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 04.08.2023.
//

import UIKit

extension UIViewController {
    func showOrHideAnimation(_ view: CustomAnimatedView,for requestResult: RequestResult?) {
        guard let requestResult
        else {
            view.stopAnimation()
            return
        }
        
        view.result = requestResult
        view.startAnimation()
    }
}
