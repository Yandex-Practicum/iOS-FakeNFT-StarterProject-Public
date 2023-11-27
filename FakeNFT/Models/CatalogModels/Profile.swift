//
//  Profile.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 17.11.2023.
//

import Foundation

struct Profile: Decodable {
    let nfts: [String]
    let likes: [String]
    let id: String
}
