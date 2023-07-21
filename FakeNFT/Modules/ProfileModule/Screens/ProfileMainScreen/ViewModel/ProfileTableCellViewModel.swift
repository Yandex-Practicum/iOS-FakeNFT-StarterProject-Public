//
//  ProfileTableCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.07.2023.
//

import Foundation

final class ProfileTableCellViewModel {
    @Published private (set) var descriptionRow: ProfileModel
    
    init(descriptionRow: ProfileModel) {
        self.descriptionRow = descriptionRow
    }
}
