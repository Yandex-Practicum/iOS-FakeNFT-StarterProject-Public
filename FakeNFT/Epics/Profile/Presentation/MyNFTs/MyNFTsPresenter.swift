import Kingfisher
import UIKit

protocol MyNFTsPresenterProtocol: AnyObject {
    var networkClient: MyNFTsNetworkClientProtocol? { get set }
    func addNFTAuthor(with id: String)
}

protocol MyNFTsViewDelegate: AnyObject {
    var view: MyNFTsViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class MyNFTsPresrnter: MyNFTsPresenterProtocol & MyNFTsViewDelegate {
    // MARK: - Public properties
    var view: MyNFTsViewControllerProtocol?
    var networkClient: MyNFTsNetworkClientProtocol?
    
    private var myNFTs: [String]
    private var nftAuthors: [String] = [] {
        didSet{
            print("🖤 \(nftAuthors)")
        }
    }
    
    // MARK: - Life cycle
    init(myNFTs: [String]){
        self.myNFTs = myNFTs
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewDidLoad() {
        getNFTResponceModels(for: myNFTs)
    }
    
    private func getNFTResponceModels(for nfts: [String]) {
        guard let networkClient = networkClient else {
            print("networkClient is nil")
            return
        }
        UIBlockingProgressHUD.show()
        for nft in nfts {
            networkClient.getNFTBy(id: nft)
        }
        getAuthorsResponceModels()
    }
    
    private func getAuthorsResponceModels() {
        for author in nftAuthors {
            networkClient?.getAuthorOfNFC(by: author)
        }
    }
    
    func addNFTAuthor(with id: String) {
        if !nftAuthors.contains(id) {
            nftAuthors.append(id)
        }
    }
}
