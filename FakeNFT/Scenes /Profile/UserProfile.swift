//
//  UserProfile.swift
//  FakeNFT
//
//  Created by Mac on 23.06.2025.
//

import Foundation
import SwiftUI

struct UserProfile: Codable {
    var name: String
    var description: String
    var link: String
    var imageData: Data?
    
    var avatarImage: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
            
        }
        return nil
    }
    
    var avatar: Image {
        if let uiImage = avatarImage {
            return Image(uiImage: uiImage)
        } else {
            return Image(.profilePhoto)
        }
    }
}
