
import Foundation

protocol MyNFTPresenterProtocol: AnyObject {
    var nftService: NftService {get}
    var servicesAssembly: ServicesAssembly {get}
    var view: MyNFTViewControllerProtocol? { get set }
    var nfts: [Nft] { get }
    var nftsID: Set<String> { get }
    var likedNft: Set<String> { get }
    var completionHandler: (([String]) -> ())? { get set }
    func isLiked(nft: Nft) -> Bool
    func viewDidLoad()
    func updateData(likesNft: Set<String>)
    func viewWillDisappear()
    func sortNFT(typeSorting: TypeSorting)
}

enum TypeSorting {
    case byName
    case byRating
    case byPrice
}

final class MyNFTPresenter: MyNFTPresenterProtocol {
    var nftService: NftService
    let servicesAssembly: ServicesAssembly
    var nftsID: Set<String>
    var likedNft: Set<String>
    
    var nfts: [Nft] = []
    var completionHandler: (([String]) -> ())?
    
    weak var view: MyNFTViewControllerProtocol?
    
    init(servicesAssembly: ServicesAssembly, nftsID: [String], likes: [String]) {
        self.servicesAssembly = servicesAssembly
        self.nftService = servicesAssembly.nftService
        self.nftsID = Set(nftsID)
        self.likedNft = Set(likes)
    }
    
    func viewDidLoad() {
        loadNfts()
    }
    
    func isLiked(nft: Nft) -> Bool {
        return likedNft.contains(nft.id)
    }
    
    private func loadNfts() {
        view?.showLoading()
        for id in nftsID {
            nftService.loadNft(id: id) { [weak self] result in
                guard let self else { return}
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    if self.nftsID.count == self.nfts.count {
                        DispatchQueue.main.async {
                            self.view?.hideLoading()
                            self.nfts.count > 0 ? self.view?.hiddenCap() : self.view?.showCap()
                            self.view?.updateUI()
                        }
                    }
                case.failure(_):
                    DispatchQueue.main.async {
                        self.view?.hideLoading()
                    }
                    break
                }
            }
        }
    }
    
    func updateData(likesNft: Set<String>) {
        self.likedNft = likesNft
    }
    
    func viewWillDisappear() {
        completionHandler?(Array(likedNft))
    }
    
    func sortNFT(typeSorting: TypeSorting) {
        if typeSorting == .byName {
            nfts.sort { $0.name.first ?? Character("") < $1.name.first ?? Character("") }
        } else if typeSorting == .byPrice {
            nfts.sort { $0.price  < $1.price}
        } else if typeSorting == .byRating {
            nfts.sort { $0.rating < $1.rating}
        }
        view?.updateUI()
    }
}

