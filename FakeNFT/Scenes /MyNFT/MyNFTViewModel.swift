import UIKit

final class MyNFTViewModel {
    
    // MARK: - Properties
    let networkClient = DefaultNetworkClient()
    
    var onChange: (() -> Void)?
    
    private weak var viewController: UIViewController?
    
    private(set) var myNFTs: [NFTNetworkModel]? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var authors: [String: String] = [:]
    
    // MARK: - Lifecycle
    init(viewController: UIViewController, nftIDs: [String]){
        self.viewController = viewController
        self.myNFTs = []
        getMyNFTs(nftIDs: nftIDs)
    }
    
    // MARK: - Methods
    func getMyNFTs(nftIDs: [String]) {
        var loadedNFTs: [NFTNetworkModel] = []
        
        nftIDs.forEach { id in
            networkClient.send(request: GetNFTByIdRequest(id: id), type: NFTNetworkModel.self) { [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nft):
                        loadedNFTs.append(nft)
                        if loadedNFTs.count == nftIDs.count {
                            self.getAuthors(nfts: loadedNFTs)
                            self.myNFTs? = loadedNFTs
                        }
                    case .failure(_):
                        self.viewController?.view = NoInternetView()
                        self.viewController?.navigationController?.navigationBar.isHidden = true
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    func getAuthors(nfts: [NFTNetworkModel]){
        var authorsSet: Set<String> = []
        nfts.forEach { nft in
            authorsSet.insert(nft.author)
        }
        let semaphore = DispatchSemaphore(value: 0)
        authorsSet.forEach { author in
            networkClient.send(request: GetAuthorByIdRequest(id: author), type: AuthorNetworkModel.self) { [self] result in
                switch result {
                case .success(let author):
                    authors.updateValue(author.name, forKey: author.id)
                    if authors.count == authorsSet.count { semaphore.signal() }
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                    return
                }
            }
        }
        semaphore.wait()
    }
}
