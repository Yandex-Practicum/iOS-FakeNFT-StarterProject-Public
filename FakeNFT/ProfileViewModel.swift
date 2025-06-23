//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Mac on 12.06.2025.
//

import Foundation
import SwiftUI
@MainActor

final class ProfileViewModel: ObservableObject {
    
    @Published var profile: ProfileModel
    
    init(profile: ProfileModel, name: String, description: String, link: String, imageData: Data? = nil) {
        self.profile = profile
        self.name = name
        self.description = description
        self.link = link
        self.imageData = imageData
    }
    @AppStorage("name") var name: String = "Joaquin Phoenix"
    
    @AppStorage("description") var description: String = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."
    
    @AppStorage("link") var link: String = "link"
    
    @AppStorage("savedImage") var imageData: Data?
   
    
}

