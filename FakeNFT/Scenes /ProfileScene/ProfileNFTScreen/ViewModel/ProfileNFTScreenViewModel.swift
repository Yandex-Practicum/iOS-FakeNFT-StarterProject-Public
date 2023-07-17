//
//  ProfileNFTScreenViewModel.swift
//  FakeNFT
//
//  Created by Илья Валито on 21.06.2023.
//

import UIKit

// MARK: ProfileNFTScreenViewModel
final class ProfileNFTScreenViewModel {

    // MARK: - Properties and Initializers
    enum SortingMethods {
        case byPrice
        case byRating
        case byName
    }

    @Observable
    private(set) var canShowUI: Bool = false

    @Observable
    private(set) var canReloadTable: Bool = false

    @Observable
    private(set) var shouldShowNetworkError: String = ""

    private let networkClient = DefaultNetworkClient()
    private weak var profile: ProfileModel?
    private let dispatchGroup = DispatchGroup()

    private var nftList: [ProfileNFTModel] = []
    private var authorsList: [AuthorModel] = []

    convenience init(profile: ProfileModel?) {
        self.init()
        self.profile = profile
        self.loadNFTList()
    }
}

// MARK: Helpers
extension ProfileNFTScreenViewModel {

    private func checkForAuthorData(withAuthorID authorID: String) {
        networkClient.send(request: AuthorRequest(authorID: authorID, httpMethod: .get),
                           type: AuthorModel.self) { author in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                do {
                    let unwrappedAuthor = try author.get()
                    self.authorsList.append(unwrappedAuthor)
                    self.dispatchGroup.leave()
                } catch {
                    self.dispatchGroup.leave()
                }

            }
        }
    }

    private func checkForNFTData(withNFTID nftID: String) {
        networkClient.send(request: ProfileNFTRequest(nftID: nftID, httpMethod: .get),
                           type: ProfileNFTModel.self) { nft in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                do {
                    let unwrappedNFT = try nft.get()
                    self.nftList.append(unwrappedNFT)
                    self.checkForAuthorData(withAuthorID: "\(unwrappedNFT.author)")
                } catch let error {
                    self.shouldShowNetworkError = "\(error)"
                }
            }
        }
    }

    func loadNFTList() {
        guard let profile else { return }
        for nftID in profile.nfts {
            dispatchGroup.enter()
            checkForNFTData(withNFTID: nftID)
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

    func sortNFT(by sortingMethod: SortingMethods) {
        switch sortingMethod {
        case .byPrice:
            nftList.sort { $0.price < $1.price }
        case .byRating:
            nftList.sort { $0.rating < $1.rating }
        case .byName:
            nftList.sort { $0.name < $1.name }
        }
        canReloadTable = true
    }

    func giveNumberOfNFTCells() -> Int {
        nftList = Array(Set(nftList))
        return nftList.count
    }

    func configureCell(forTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = NFTCell()
        let nft = nftList[indexPath.row]
        cell.nftImageView.loadImage(urlString: nft.images.first)
        if let profile {
            if profile.likes.contains(nft.id) {
                cell.nftLikeButton.setImage(UIImage(named: Constants.IconNames.activeLike), for: .normal)
            }
        }
        cell.nftNameLabel.text = nft.name
        cell.setRating(to: nft.rating)
        cell.nftAuthorLabel.text = "ОТ \(authorsList.first(where: { $0.id == nft.author})?.name ?? "")"
        cell.nftPriceAmountLabel.text = "\(nft.price) ETH"
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = true
        cell.contentView.isHidden = true
        cell.backgroundColor = .clear
        return cell
    }

    func proceedLike(forRow row: Int?) {
        guard let row,
              let profile else { return }
        let nftToProceed = nftList[row]
        if profile.likes.contains(nftToProceed.id) {
            profile.likes.removeAll(where: {$0 == nftToProceed.id})
        } else {
            profile.likes.append(nftToProceed.id)
        }
        uploadData()
        canReloadTable = true
    }

    func deleteNFT(atRow row: Int?) {
        guard let row else { return }
        let nftToRemove = nftList.remove(at: row)
        profile?.nfts.removeAll(where: {$0 == nftToRemove.id})
        uploadData()
    }
}
