//
//  Cordinator.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 21.03.2025.
//

import UIKit

protocol ProfileCoordinator {
    func initialScene()
    func profileEditingScene(profile: Profile)
    func myNftsScene(nfts: [String])
    func favouritesScene(likes: [String])
    func webViewScene(url: URL)
}
