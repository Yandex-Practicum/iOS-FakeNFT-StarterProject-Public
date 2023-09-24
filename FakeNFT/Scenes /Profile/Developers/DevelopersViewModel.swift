//
//  DevelopersViewModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 22.09.2023.
//

import Foundation

final class DevelopersViewModel {
    // MARK: - Properties

    let getDevsData = DevelopersModel.shared
    private (set) var devs: [Developers] = [] {
        didSet {
            myDevsDidChange?()
        }
    }

    var myDevsDidChange: (() -> Void)?

    init() {
        getDevs()
    }
    // MARK: - Methods

    func getDevs() {
        self.devs = getDevsData.getAllDevs()
    }
}
