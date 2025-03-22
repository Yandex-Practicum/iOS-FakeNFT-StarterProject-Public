//
//  ProfileViewModels.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 19.03.2025.
//

import Foundation

protocol ProfileViewModel {
    var profile: Observable<Profile?> { get }
    var errorModel: Observable<ErrorModel?> { get }
    
    func viewWillAppear()
    func editButtonDidTap()
    func myNftsCellDidSelect()
    func favouritesCellDidSelect()
    func aboutDeveloperCellDidSelect()
    func linkButtonDidTap()
}
