//
//  PurchaseBackgroundView.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 01.08.2023.
//

import UIKit

final class PurchaseBackgroundView: UIView {
    private let cornerRadius = 12

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PurchaseBackgroundView {
    func configure() {
        self.backgroundColor = .appLightGray
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
