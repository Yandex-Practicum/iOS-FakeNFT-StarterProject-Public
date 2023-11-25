import Foundation
import ProgressHUD

enum LoadingState {
    case idle
    case loading
    case loaded
    case error(Error)
}

protocol UserNFTViewModelProtocol {
    var userNFT: [NFT]? { get }
    var authors: [String: Author] { get }
    var state: LoadingState { get }
    
    func observeUserNFT(_ handler: @escaping ([NFT]?) -> Void)
    func observeState(_ handler: @escaping (LoadingState) -> Void)
    
    func fetchNFT(nftList: [String])
    func fetchAuthor(authorID: String, completion: @escaping (Result<Author, Error>) -> Void)
    
    func userSelectedSorting(by option: SortOption)
}

final class UserNFTViewModel: UserNFTViewModelProtocol {
    @Observable
    private (set) var userNFT: [NFT]?
    
    @Observable
    private (set) var state: LoadingState = .idle
    
    private (set) var authors: [String: Author] = [:]
    private let model: UserNFTModel
    
    init(model: UserNFTModel) {
        self.model = model
    }
    
    func observeUserNFT(_ handler: @escaping ([NFT]?) -> Void) {
        $userNFT.observe(handler)
    }
    
    func observeState(_ handler: @escaping (LoadingState) -> Void) {
        $state.observe(handler)
    }
    
    func fetchNFT(nftList: [String]) {
        ProgressHUD.show(NSLocalizedString("ProgressHUD.loading", comment: ""))
        state = .loading

        var fetchedNFTs: [NFT] = []
        let group = DispatchGroup()
        
        for element in nftList {
            group.enter()
            
            model.fetchNFT(nftID: element) { (result) in
                switch result {
                case .success(let nft):
                    fetchedNFTs.append(nft)
                case .failure(let error):
                    print("Failed to fetch NFT with ID \(element): \(error)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.fetchAuthor(nfts: fetchedNFTs)
        }
    }
    
    func fetchAuthor(authorID: String, completion: @escaping (Result<Author, Error>) -> Void) {
        model.fetchAuthor(authorID: authorID) { result in
            switch result {
            case .success(let author):
                completion(.success(author))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func userSelectedSorting(by option: SortOption) {
        guard var nfts = userNFT else {
            print("No NFTs available to sort")
            return
        }

        switch option {
        case .price:
            nfts.sort(by: { $0.price > $1.price })
        case .rating:
            nfts.sort(by: { $0.rating > $1.rating })
        case .title:
            nfts.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        }
        self.userNFT = nfts
    }
    
    private func fetchAuthor(nfts: [NFT]) {
        let authorGroup = DispatchGroup()
        
        for nft in nfts {
            authorGroup.enter()
            self.fetchAuthor(authorID: nft.author) { result in
                switch result {
                case .success(let author):
                    self.authors[nft.author] = author
                case .failure(let error):
                    print("Failed to fetch author with ID \(nft.author): \(error)")
                }
                authorGroup.leave()
            }
        }
        authorGroup.notify(queue: .main) {
            self.userNFT = nfts
            self.state = .loaded
        }
        ProgressHUD.dismiss()
    }
}
