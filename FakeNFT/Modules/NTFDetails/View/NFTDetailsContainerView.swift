//
//  NFTDetailsContainerView.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

class NFTDetailsContainerView: UIView {
    private let details: NFTDetails

    init(details: NFTDetails) {
        self.details = details
        super.init(frame: .null)
        setupSubViews()
        backgroundColor = .appWhite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {

    }

}
