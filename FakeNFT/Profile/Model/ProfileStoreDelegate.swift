//
//  ProfileStoreDelegate.swift
//  FakeNFT
//

import Foundation

protocol ProfileStoreDelegate: AnyObject {
    func didReceive(_ profile: ProfileModel)
}
