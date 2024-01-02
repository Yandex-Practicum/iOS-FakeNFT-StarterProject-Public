import Foundation

protocol MyNFTCellPresenterProtocol: AnyObject {
    var view: MyNFTCellView? {get set}
    var likedNfts: Set<String> { get }
    var delegate: MyNFTViewControllerProtocol? { get set}
    var nft: Nft? {get}
    func loadImage()
    func likeButtonDidTapped()
    func isLiked() -> Bool
}

final class MyNFTCellPresenter: MyNFTCellPresenterProtocol {

    weak var view: MyNFTCellView?
    let servicesAssembly: ServicesAssembly?
    
    let nft: Nft?
    var likedNfts: Set<String>
    weak var delegate: MyNFTViewControllerProtocol?
    
    init(view: MyNFTCellView? = nil,
         nft: Nft?,
         likedNfts: Set<String>,
         servicesAssembly: ServicesAssembly?)
    {
        self.view = view
        self.nft = nft
        self.likedNfts = likedNfts
        self.servicesAssembly = servicesAssembly
    }
    
    func loadImage() {
        let url = nft?.images.first
        guard let url else { return }
        view?.showLoading()
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.hideLoading()
                self.view?.setImage(data: data)
            }
        }.resume()
    }
    
    func likeButtonDidTapped() {
        view?.unenabledLikeButton()
        view?.showLoading()
        guard let idLikedNFt = nft?.id else { return }
        var likedNftsSet = likedNfts
        if likedNftsSet.contains(idLikedNFt) {
            likedNftsSet.remove(idLikedNFt)
        } else {
            likedNftsSet.insert(idLikedNFt)
        }
        servicesAssembly?.profileService.saveProfile(
            profileEditing: ProfileModelEditing(likes: Array(likedNftsSet))) { [weak self, likedNftsSet] result in
                guard let self else { return }
                self.view?.enabledLikeButton()
                self.view?.hideLoading()
                switch result {
                case .success(_):
                    self.likedNfts = likedNftsSet
                    self.delegate?.presenter?.updateData(likesNft: likedNftsSet)
                    self.view?.updateLikeImage()
                case .failure(_):
                    break
                }
            }
    }
    
    func isLiked() -> Bool {
        return likedNfts.contains(nft?.id ?? "")
    }
    
}
