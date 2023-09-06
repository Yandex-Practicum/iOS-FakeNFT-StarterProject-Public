//
//  NftAvatarViewModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 06.09.2023.
//

import UIKit

struct NftAvatarViewModel {
    let imageURL: URL?
    var isLiked: Bool?
    let likeButtonAction: (() -> Void)?
}
