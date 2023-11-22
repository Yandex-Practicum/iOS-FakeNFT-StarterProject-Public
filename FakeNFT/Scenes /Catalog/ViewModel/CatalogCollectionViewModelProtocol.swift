//
//  CatalogCollectionViewModelProtocol.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 22.11.2023.
//

import Foundation

protocol CatalogCollectionViewModelProtocol: AnyObject {
    var nftsLoadingIsCompleted: Bool { get }
    var nftsLoaderPuublisher: Published<Bool>.Publisher { get }
    var nfts: [Nft] { get }
    var catalogCollection: Catalog { get }
    var author: Author? { get }
    var authorPublisher: Published<Author?>.Publisher { get }
    var networkError: Error? { get }
    var networkErrorPublisher: Published<Error?>.Publisher { get }
    var profileLikes: [String] { get set }
    func calculateCollectionViewHeight() -> CGFloat
    func fetchData()
    func changeLikeForNft(with id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func nftIsLiked(_ id: String) -> Bool
    func nftsIsAddedToCart(_ id: String) -> Bool
    func switchNftBasketState(with id: String, completion: @escaping (Result<Void, Error>) -> Void)
}
