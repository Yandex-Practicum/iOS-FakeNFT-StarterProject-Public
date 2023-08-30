import Foundation

protocol StatisticNFTCollectionViewModelProtocol {
    var nftsObservable: Observable<NFTCells> { get }
    var likeStatusDidChangeObservable: Observable<Bool> { get }
    var cartStatusDidChangeObservable: Observable<Bool> { get }
    
    func changeNFTCartStatus(isAddedToCart: Bool, id: String)
    func changeNFTFavouriteStatus(isLiked: Bool, id: String)
}
