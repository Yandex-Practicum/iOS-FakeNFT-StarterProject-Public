//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let style: UIAlertAction.Style
    let completion: (() -> Void)?
}
