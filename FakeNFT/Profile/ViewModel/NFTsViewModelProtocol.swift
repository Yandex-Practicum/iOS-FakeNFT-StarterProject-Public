//
//  NFTViewModelProtocol.swift
//  FakeNFT
//

import Foundation

protocol NFTsViewModelProtocol {
    var myNFTsTitle: String { get }
    var favoritesNFTsTitle: String { get }
    var nftViewModels: [NFTViewModel] { get }
    var nftViewModelsObservable: Observable<[NFTViewModel]> { get }
    var isNFTsDownloadingNowObservable: Observable<Bool> { get }
    var nftsReceivingErrorObservable: Observable<String> { get }
    var stubLabelIsHidden: Bool { get }
    func nftViewDidLoad()
    func myNFTSorted(by sortingMethod: SortingMethod)
    func didTapLike(nft: Int, callback: @escaping () -> Void)
}
