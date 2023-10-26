import UIKit

protocol MyNFTViewModelProtocol: AnyObject {

    var nftCardsObservable: Observable<NFTCards?> { get }
    var usersObservable: Observable<Users?> { get }
    var profileObservable: Observable<Profile?> { get }

    func fetchNtfCards(nftIds: [String])
    func sortNFTCollection(option: SortingOption)
    func changeProfile(likesIds: [String])
    var showErrorAlert: ((String) -> Void)? { get set }
}
