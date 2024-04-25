//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 25.04.2024.
//

import Foundation

protocol MyNFTPresenterProtocol: AnyObject {
    var view: MyNFTViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class MyNFTPresenter {
    //MARK:  - Public Properties
    weak var view: MyNFTViewControllerProtocol?
    var nfts: [NFT] = []
    var nftID: [String]
    var likedNFT: [String]
    
    // MARK: - Private Properties
    private let profileNFTService = ProfileNFTService.shared
    private let editProfileService: EditProfileService
    weak var likesDelegate: MyNFTLikesDelegate?
    
    // MARK: - Initializers
    init(nftID: [String], likedNFT: [String], editProfileService: EditProfileService) {
        self.nftID = nftID
        self.likedNFT = likedNFT
        self.editProfileService = editProfileService
    }
    
    // MARK: - Public Methods
    func tapLike(id: String) {
        if likedNFT.contains(id) {
            likedNFT.removeAll(where: {$0 == id})
        } else {
            likedNFT.append(id)
        }
        updateLikes()
        view?.updateMyNFTs(nfts: nfts)
    }
    
    func isLiked(id: String) -> Bool {
        return likedNFT.contains(id)
    }
    
    // MARK: - Private Methods
    private func fetchNFTs() {
        var allNFTs: [NFT] = []
        let group = DispatchGroup()
        
        for id in nftID {
            group.enter()
            
            profileNFTService.fetchNFTs(id) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let nfts):
                    allNFTs.append(nfts)
                case .failure(let error):
                    print("Failed to fetch NFTs: \(error)")
                }
            }
            group.notify(queue: .main) { [weak self] in
                allNFTs.sort(by: { $0.rating > $1.rating })
                self?.view?.updateMyNFTs(nfts: allNFTs)
            }
        }
    }
    
    private func updateLikes() {
        let model = EditProfile(
            name: nil,
            avatar: nil,
            description: nil,
            website: nil,
            likes: likedNFT
        )
        editProfileService.updateProfile(with: model) { result in
            switch result {
            case .success:
                print("Успешно")
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}

// MARK: - MyNFTPresenterProtocol
extension MyNFTPresenter: MyNFTPresenterProtocol {
    func viewDidLoad() {
        fetchNFTs()
    }
}

