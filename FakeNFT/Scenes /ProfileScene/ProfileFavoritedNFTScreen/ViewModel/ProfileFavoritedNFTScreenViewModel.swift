//
//  ProfileFavoritedNFTScreenViewModel.swift
//  FakeNFT
//
//  Created by Илья Валито on 23.06.2023.
//

import UIKit

// MARK: ProfileNFTScreenViewModel
final class ProfileFavoritedNFTScreenViewModel {

    // MARK: - Properties and Initializers
    enum SortingMethods {
        case byPrice
        case byRating
        case byName
    }

    @Observable
    private(set) var canShowUI: Bool = false

    @Observable
    private(set) var canReloadCollection: Bool = false

    @Observable
    private(set) var shouldShowNetworkError: String = ""

    private let networkClient = DefaultNetworkClient()
    private weak var profile: ProfileModel?
    private let dispatchGroup = DispatchGroup()

    private var nftList: [ProfileNFTModel] = []

    convenience init(profile: ProfileModel?) {
        self.init()
        self.profile = profile
        self.loadFavoritedNFTList()
    }
}

// MARK: Helpers
extension ProfileFavoritedNFTScreenViewModel {

    private func checkForFavoritedNFTData(withNFTID nftID: String) {
        networkClient.send(request: ProfileNFTRequest(nftID: nftID, httpMethod: .get),
                           type: ProfileNFTModel.self) { nft in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                do {
                    let unwrappedNFT = try nft.get()
                    self.nftList.append(unwrappedNFT)
                    self.dispatchGroup.leave()
                } catch let error {
                    self.shouldShowNetworkError = "\(error)"
                }
            }
        }
    }

    func loadFavoritedNFTList() {
        guard let profile else { return }
        for nftID in profile.likes {
            dispatchGroup.enter()
            checkForFavoritedNFTData(withNFTID: nftID)
        }
        dispatchGroup.notify(queue: .main) {
            self.canShowUI = true
        }
    }

    func uploadData() {
        networkClient.send(request: ProfileRequest(httpMethod: .put, dto: profile),
                           type: ProfileModel.self
        ) { _ in
            return
        }
    }

    func giveNumberOfFavoritedNFTCells() -> Int {
        nftList = Array(Set(nftList))
        return nftList.count
    }

    func configureCell(forCollectionView collectionView: UICollectionView,
                       indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritedNFTCell.reuseIdentifier,
            for: indexPath
        ) as? FavoritedNFTCell else {
            return UICollectionViewCell()
        }
        let nft = nftList[indexPath.row]
        cell.nftImageView.loadImage(urlString: nft.images.first)
        if let profile {
            if profile.likes.contains(nft.id) {
                cell.nftLikeButton.setImage(UIImage(named: Constants.IconNames.activeLike), for: .normal)
            }
        }
        cell.nftNameLabel.text = nft.name
        cell.setRating(to: nft.rating)
        cell.nftPriceAmountLabel.text = "\(nft.price) ETH"
        cell.isUserInteractionEnabled = true
        cell.contentView.isHidden = true
        return cell
    }

    func proceedLike(forItem item: Int?) {
        guard let item,
              let profile else { return }
        let nftToProceed = nftList[item]
        nftList.removeAll(where: { $0.id == nftToProceed.id })
        profile.likes.removeAll(where: {$0 == nftToProceed.id})
        uploadData()
        canReloadCollection = true
    }
}
