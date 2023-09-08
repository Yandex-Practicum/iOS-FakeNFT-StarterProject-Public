//
//  UploadProfileModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation

struct UploadProfileModel: Encodable {
    let name: String?
    let description: String?
    let website: URL
    let likes: [String]?
}
