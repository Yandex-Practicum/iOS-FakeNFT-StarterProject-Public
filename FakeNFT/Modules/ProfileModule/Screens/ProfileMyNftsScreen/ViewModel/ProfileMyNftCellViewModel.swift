//
//  ProfileMyNftCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.07.2023.
//

import Foundation
import Combine

final class ProfileMyNftCellViewModel {
    @Published private (set) var cellModel: VisibleSingleNfts
    
    init(cellModel: VisibleSingleNfts) {
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
