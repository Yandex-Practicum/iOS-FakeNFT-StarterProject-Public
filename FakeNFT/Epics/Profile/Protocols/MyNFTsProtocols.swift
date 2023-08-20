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
    var currentSortOption: ProfileSortOption { get set }
    var counterOfNFTs: Int { get }
    var missingNFCLabelIsNeedToHide: Bool { get }
    var callback: (() -> Void)? { get }
    func viewDidLoad()
    func getModelFor(indexPath: IndexPath) -> MyNFTPresentationModel
}
