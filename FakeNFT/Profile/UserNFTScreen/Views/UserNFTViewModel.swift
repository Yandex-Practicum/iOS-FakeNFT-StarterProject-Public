import Foundation
import ProgressHUD

protocol UserNFTViewModelProtocol {
    var userNFT: [NFT]? { get }
    var authors: [String: Author] { get }
    var state: LoadingState { get }
    
    func observeUserNFT(_ handler: @escaping ([NFT]?) -> Void)
    func observeState(_ handler: @escaping (LoadingState) -> Void)
    
    func viewDidLoad(nftList: [String])
    func viewWillDisappear()
    
    func userSelectedSorting(by option: SortOption)
}

final class UserNFTViewModel: UserNFTViewModelProtocol {
    @Observable
    private (set) var userNFT: [NFT]?
    
    @Observable
    private (set) var state: LoadingState = .idle
    
    private (set) var authors: [String: Author] = [:]
    private let service: NFTService
    
    init(nftService: NFTService) {
        self.service = nftService
    }
    
    func observeUserNFT(_ handler: @escaping ([NFT]?) -> Void) {
        $userNFT.observe(handler)
    }
    
    func observeState(_ handler: @escaping (LoadingState) -> Void) {
        $state.observe(handler)
    }
    
    func viewDidLoad(nftList: [String]) {
        ProgressHUD.show(NSLocalizedString("ProgressHUD.loading", comment: ""))
        state = .loading
        
        var fetchedNFTs: [NFT] = []
        let group = DispatchGroup()
        
        for element in nftList {
            group.enter()
            
            service.fetchNFT(nftID: element) { (result) in
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
            self.fetchAuthorList(nfts: fetchedNFTs)
        }
    }
    
    func viewWillDisappear() {
        service.stopAllTasks()
        ProgressHUD.dismiss()
    }
    
    func userSelectedSorting(by option: SortOption) {
        guard var nfts = userNFT else {
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
    
    private func fetchAuthorList(nfts: [NFT]) {
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
            self.state = .loaded(hasData: !nfts.isEmpty)
            ProgressHUD.dismiss()
        }
    }
    
    private func fetchAuthor(authorID: String, completion: @escaping (Result<Author, Error>) -> Void) {
        service.fetchAuthor(authorID: authorID) { result in
            switch result {
            case .success(let author):
                completion(.success(author))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
