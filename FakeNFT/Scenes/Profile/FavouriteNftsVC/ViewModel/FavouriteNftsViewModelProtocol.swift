import UIKit

protocol FavouriteNftsViewModelProtocol: AnyObject {
    
    var nftCardsObservable: Observable<NFTCards?> { get }
    var usersObservable: Observable<Users?> { get }
    var profileObservable: Observable<Profile?> { get }
    func fetchNtfCards(likes: [String])
    func changeProfile(likesIds: [String])
    var showErrorAlert: ((String) -> Void)? { get set }
}
