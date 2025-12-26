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
    @AppStorage("userData") private var storedData: Data = Data()
    
    @Published var name: String = "Joaquin Phoenix"
    
    @Published var description: String = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."
    
    @Published var link: String = "link"
    
    @Published var imageData: Data?
    
    init() {
        load()
    }
    
    func load() {
        if let loaded = try? JSONDecoder().decode(UserData.self, from: storedData) {
            self.name = loaded.name
            self.description = loaded.description
            self.link = loaded.link
            self.imageData = loaded.imageData
        }
    }
    
    func save(name: String, description: String, link: String, imageData: Data?) {
        let newData = UserData(name: name, description: description, link: link, imageData: imageData)
            if let encoded = try? JSONEncoder().encode(newData) {
                storedData = encoded
                self.name = name
                self.description = description
                self.link = link
                self.imageData = imageData
            }
        }
}


