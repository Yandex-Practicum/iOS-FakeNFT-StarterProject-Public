//
//  ProfileViewModelProtocol.swift
//  FakeNFT
//

import Foundation

protocol ProfileViewModelProtocol: AnyObject {

    var nameObservable: Observable<String> { get }
    var avatarURLObservable: Observable<URL?> { get }
    var descriptionObservable: Observable<String> { get }
    var websiteObservable: Observable<String> { get }
    var nftsObservable: Observable<[Int]> { get }
    var likesObservable: Observable<[Int]> { get }
    var isProfileUpdatingNowObservable: Observable<Bool> { get }
    var profileReceivingErrorObservable: Observable<String> { get }

    func profileViewDidLoad()
    func labelTextFor(_ profileOption: ProfileOption) -> String
    func didSelect(_ profileOption: ProfileOption) -> ViewModelProtocol
    func didChangeProfile(name: String?,
                          description: String?,
                          website: String?,
                          avatar: String?,
                          likes: [Int]?,
                          viewCallback: @escaping () -> Void)
}
