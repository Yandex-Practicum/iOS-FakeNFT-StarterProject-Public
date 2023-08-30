import Foundation

protocol NFTCollectionCellDelegate: AnyObject {
    func likeButtonDidTapped(cell: NFTCollectionCell)
    func addToCardButtonDidTapped(cell: NFTCollectionCell)
}
