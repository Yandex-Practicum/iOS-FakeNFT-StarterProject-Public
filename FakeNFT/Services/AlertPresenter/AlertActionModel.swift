//
//  AlertActionModel.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 17.08.2023.
//

import UIKit

struct AlertActionModel {
    let buttonText: String
    let style: UIAlertAction.Style
    let completion: () -> Void
}
