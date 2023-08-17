import UIKit

// MARK: - MyNFTsViewControllerProtocol

protocol MyNFTsViewControllerProtocol {
    var presenter: MyNFTsViewDelegate? { get set }
    func updateTable()
    func showNetworkErrorAlert(with error: Error)
}

// MARK: - MyNFTsPresenterProtocol

protocol MyNFTsPresenterProtocol: AnyObject {
    var networkClient: NFTsNetworkClientProtocol? { get set }
}

// MARK: - MyNFTsViewDelegate

protocol MyNFTsViewDelegate: AnyObject {
    var view: MyNFTsViewControllerProtocol? { get set }
    var callback: (() -> Void)? { get set }
    func viewDidLoad()
    func getMyNFTsCounter() -> Int
    func isNeedToHideMissingNFCLabel() -> Bool
    func getModelFor(indexPath: IndexPath) -> MyNFTPresentationModel
    func sortMyNFTs(by option: ProfileSortOption)
}
