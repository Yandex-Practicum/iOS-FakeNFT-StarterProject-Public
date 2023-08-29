import UIKit

// MARK: - FavoriteNFTsPresenterProtocol

protocol FavoriteNFTsPresenterProtocol: AnyObject {
    var networkClient: NFTsNetworkClientProtocol? { get set }
}

// MARK: - FavoriteNFTsViewDelegate

protocol FavoriteNFTsViewDelegate: AnyObject {
    var view: NFTsViewControllerProtocol? { get set }
    var counterOfNFTs: Int { get }
    var placeholderLabelIsNeedToHide: Bool { get }
    var callback: (() -> Void)? { get }
    func viewDidLoad()
    func getModelFor(indexPath: IndexPath) -> MyNFTPresentationModel
    func deleteNFT(at indexPath: IndexPath)
}

// MARK: - NFTsViewControllerProtocol

protocol NFTsViewControllerProtocol {
    var presenter: FavoriteNFTsViewDelegate? { get set }
    func updateTableOrCollection()
    func showNetworkErrorAlert(with error: Error)
}

// MARK: - FavoriteNFTCellDelegate

protocol FavoriteNFTCellDelegate: AnyObject {
    func didTapLikeButton(at indexPath: IndexPath)
}
