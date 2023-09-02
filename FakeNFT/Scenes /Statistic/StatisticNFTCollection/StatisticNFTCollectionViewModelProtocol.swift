import Foundation

protocol StatisticNFTCollectionViewModelProtocol {
    var nftsObservable: Observable<NFTCells> { get }
    var likeStatusDidChangeObservable: Observable<Bool> { get }
    var cartStatusDidChangeObservable: Observable<Bool> { get }
    var networkErrorObservable: Observable<String?> { get }

    func fetchUsersNFT()
    func changeNFTCartStatus(isAddedToCart: Bool, id: String)
    func changeNFTFavouriteStatus(isLiked: Bool, id: String)
}
