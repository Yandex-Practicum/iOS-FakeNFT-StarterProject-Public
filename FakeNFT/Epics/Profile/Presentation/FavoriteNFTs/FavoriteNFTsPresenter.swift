import Kingfisher
import UIKit

final class FavoriteNFTsPresenter: FavoriteNFTsPresenterProtocol & FavoriteNFTsViewDelegate {
    // MARK: - Public properties
    
    var view: NFTsViewControllerProtocol?
    var networkClient: NFTsNetworkClientProtocol?
    var profileNetworkClient: ProfileNetworkClientProtocol?
    
    var callback: (() -> Void)?
    
    // MARK: - Private properties
    
    private let oldProfile: ProfileResponseModel
    private var profile: ProfileResponseModel
    private var nftAuthors: Set<String> = []
    
    private var myNFTsResponces: [NFTResponseModel] = []
    private var nftAuthorsResponces: [AuthorResponseModel] = []
    private var presentationModels: [MyNFTPresentationModel] = []
    
    // MARK: - Life cycle
    
    init(profile: ProfileResponseModel) {
        self.oldProfile = profile
        self.profile = profile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public properties
    
    func getCurrentProfileResponse() -> ProfileResponseModel? {
        profile == oldProfile ? nil : profile
    }
    
    // MARK: - MyNFTsViewDelegate
    
    func viewDidLoad() {
        presentationModels = []
        nftAuthorsResponces = []
        myNFTsResponces = []
        
        getNFTResponceModels(for: profile.likes)
    }
    
    func deleteNFT(at indexPath: IndexPath) {
        guard indexPath.row < presentationModels.count else { return }
        let deletedId = profile.likes[indexPath.row]
        setNewProfile(without: deletedId)
        presentationModels.remove(at: indexPath.row)
        updateProfile(with: profile)
        view?.updateTableOrCollection()
    }
    
    func getNFTsCounter() -> Int {
        presentationModels.count
    }
    
    func isNeedToHidePlaceholderLabel() -> Bool {
        !profile.likes.isEmpty && !presentationModels.isEmpty ? true : false
    }
    
    func getModelFor(indexPath: IndexPath) -> MyNFTPresentationModel {
        return presentationModels[indexPath.row]
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
                isLiked: true
            )
            presentationModels.append(nftPresentationModel)
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.updateTableOrCollection()
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func setNewProfile(without id: String) {
        let updatedLikes = profile.likes.filter { $0 != id }
        
        let updatedProfile = ProfileResponseModel(
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nfts: profile.nfts,
            likes: updatedLikes,
            id: profile.id
        )
        profile = updatedProfile
    }
}


// MARK: - ProfilePresenterNetworkProtocol

extension FavoriteNFTsPresenter: ProfilePresenterNetworkProtocol {
    func showAlert(with error: Error) {
    }
    
    func getProfile(with data: ProfileResponseModel) {
    }
    
    func updateProfile(with data: ProfileResponseModel) {
        UIBlockingProgressHUD.show()
        profileNetworkClient?.updateProfile(with: data) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self.view?.showNetworkErrorAlert(with: error)
                }
            }
        }
    }
}
