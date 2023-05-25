//
//  ProfileStoreProtocol.swift
//  FakeNFT
//

import Foundation

protocol ProfileStoreProtocol {
    var delegate: ProfileStoreDelegate? { get set }
    func fetchProfile()
}
