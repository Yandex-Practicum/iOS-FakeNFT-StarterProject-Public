import Kingfisher
import UIKit

protocol MyNFTsPresenterProtocol: AnyObject {
    var networkClient: MyNFTsNetworkClientProtocol? { get set }
}

protocol MyNFTsViewDelegate: AnyObject {
    var view: MyNFTsViewControllerProtocol? { get set }
    func viewDidLoad()
    func getMyNFTsCounter() -> Int
    func isNeedToHideMissingNFCLabel() -> Bool
    func getModelFor(indexPath: IndexPath) -> MyNFTPresentationModel
}

final class MyNFTsPresrnter: MyNFTsPresenterProtocol & MyNFTsViewDelegate {
    // MARK: - Public properties
    var view: MyNFTsViewControllerProtocol?
    var networkClient: MyNFTsNetworkClientProtocol?
    
    // MARK: - Private properties
    private var profile: ProfileResponseModel
    private var nftAuthors: Set<String> = []
    
    private var myNFTsResponces: [NFTResponseModel] = []
    private var nftAuthorsResponces: [AuthorResponseModel] = []
    private var presentationModels: [MyNFTPresentationModel] = []
    
    
    // MARK: - Life cycle
    init(profile: ProfileResponseModel){
        self.profile = profile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - MyNFTsViewDelegate
    func viewDidLoad() {
        getNFTResponceModels(for: profile.nfts)
    }
    
    
    func getMyNFTsCounter() -> Int {
        myNFTsResponces.count
    }
    
    func isNeedToHideMissingNFCLabel() -> Bool {
        !profile.nfts.isEmpty
    }
    
    func getModelFor(indexPath: IndexPath) -> MyNFTPresentationModel {
        presentationModels[indexPath.row]
    }
    // MARK: - Private Methods
    private func addNFT(responce: NFTResponseModel) {
        myNFTsResponces.append(responce)
    }
    
    private func addAuthor(responce: AuthorResponseModel) {
        nftAuthorsResponces.append(responce)
    }
    
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
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        UIBlockingProgressHUD.dismiss()
                        self.view?.showNetworkErrorAlert(with: error)
                    }
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
            networkClient.getAuthorOfNFC(by: author){ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.nftAuthorsResponces.append(result)
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        UIBlockingProgressHUD.dismiss()
                        self.view?.showNetworkErrorAlert(with: error)
                    }
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
            let nftPresentationModel = MyNFTPresentationModel(
                nftName: responce.name,
                authorName: authorName,
                image: image,
                price: responce.price,
                rating: String(responce.rating),
                isLiked: isThisNFCLiked(id: responce)
            )
            presentationModels.append(nftPresentationModel)
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.updateTable()
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func isThisNFCLiked(id model: NFTResponseModel) -> Bool {
        return profile.likes.contains(model.id)
    }
}
