//
//  NFTViewModelProtocol.swift
//  FakeNFT
//

import Foundation

protocol NFTsViewModelProtocol {
    var nftViewModels: [NFTViewModel] { get }
    var nftViewModelsObservable: Observable<[NFTViewModel]> { get }
    var authorsObservable: Observable<[AuthorViewModel]> { get }
    var isNFTsDownloadingNowObservable: Observable<Bool> { get }
    func get(_ nfts: [Int])
    func getAuthors()
}
