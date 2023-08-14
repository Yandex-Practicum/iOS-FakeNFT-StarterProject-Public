import Kingfisher
import UIKit

protocol MyNFTsPresenterProtocol: AnyObject {
    var networkClient: MyNFTsNetworkClientProtocol? { get set }
}

protocol MyNFTsViewDelegate: AnyObject {
    var view: MyNFTsViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class MyNFTsPresrnter: MyNFTsPresenterProtocol & MyNFTsViewDelegate {
    // MARK: - Public properties
    var view: MyNFTsViewControllerProtocol?
    var networkClient: MyNFTsNetworkClientProtocol?
    
    // MARK: - Private properties
    private var myNFTs: [String]
    private var nftAuthors: Set<String> = []
    
    private var myNFTsResponces: [NFTResponseModel] = []
    private var nftAuthorsResponces: [AuthorResponseModel] = []
    private var presentationModels: [MyNFCPresentationModel] = []
    
    
    // MARK: - Life cycle
    init(myNFTs: [String]){
        self.myNFTs = myNFTs
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - MyNFTsViewDelegate
    func viewDidLoad() {
        getNFTResponceModels(for: myNFTs)
    }
    
    
    // MARK: - Public Methods
    private func addNFT(responce: NFTResponseModel) {
        myNFTsResponces.append(responce)
    }
    
    private func addAuthor(responce: AuthorResponseModel) {
        nftAuthorsResponces.append(responce)
    }
    
    // MARK: - Private Methods
    private func getNFTResponceModels(for nfts: [String]) {
        guard let networkClient = networkClient else {
            print("networkClient is nil")
            return
        }
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        let dispatchGroup = DispatchGroup()
        
        for nft in nfts {
            dispatchGroup.enter()
            networkClient.getNFTBy(id: nft){ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let responce):
                    self.addNFT(responce: responce)
                    self.nftAuthors.insert(responce.author)
                case .failure(let error):
                    DispatchQueue.main.async {
                        UIBlockingProgressHUD.dismiss()
                    }
                    // TODO: Добавить вызов алерт презентера
                    print("\n❌ \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("All NFT requests completed.")
            self.getAuthorsResponceModels()
        }
    }
    
    
    private func getAuthorsResponceModels() {
        guard let networkClient = networkClient else {
            print("networkClient is nil")
            return
        }
        let dispatchGroup = DispatchGroup()
        
        for author in nftAuthors {
            dispatchGroup.enter()
            networkClient.getAuthorOfNFC(by: author) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.nftAuthorsResponces.append(result)
                case .failure(let error):
                    DispatchQueue.main.async {
                        UIBlockingProgressHUD.dismiss()
                    }
                    // TODO: Добавить вызов алерт презентера
                    print("\n❌❌ \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("All author requests completed.")
            self.createNFCPresentationModels()
        }
    }
    
    
    private func createNFCPresentationModels() {
        for responce in myNFTsResponces {
            let author = nftAuthorsResponces.first { $0.id == responce.author }
            guard
                let authorName = author?.name,
                let image = responce.images.first
            else {
                return
            }
            let nftPresentationModel = MyNFCPresentationModel(
                nftName: responce.name,
                authorName: authorName,
                image: image,
                price: responce.price,
                rating: String(responce.rating)
            )
            presentationModels.append(nftPresentationModel)
        }
        DispatchQueue.main.async {
            UIBlockingProgressHUD.dismiss()
        }
    }
}
