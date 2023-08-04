//
//  ProgressHUDWrapper.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import Foundation
import ProgressHUD

struct ProgressHUDWrapper {
    static func show() {
        ProgressHUD.show()
    }

    static func hide() {
        ProgressHUD.dismiss()
    }
}
