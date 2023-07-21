//
//  ProfileLikedNftsCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.07.2023.
//

import Foundation

final class ProfileLikedNftsCellViewModel {
    @Published private (set) var cellModel: LikedSingleNfts
    
    init(cellModel: LikedSingleNfts) {
        self.cellModel = cellModel
    }
    
    func createUrl(from stringUrl: String?) -> URL? {
        guard let stringUrl,
              let encodedStringUrl = stringUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed)
        else { return nil }
        
        return URL(string: encodedStringUrl)
    }
}
