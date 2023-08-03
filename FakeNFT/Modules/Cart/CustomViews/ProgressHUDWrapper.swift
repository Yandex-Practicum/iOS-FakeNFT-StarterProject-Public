//
//  ProgressHUDWrapper.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import Foundation
import ProgressHUD

struct ProgressHUDWrapper {
    init() {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorAnimation = .black
        ProgressHUD.colorBackground = .lightGray
    }

    func show() {
        ProgressHUD.show()
    }

    func hide() {
        ProgressHUD.dismiss()
    }
}
