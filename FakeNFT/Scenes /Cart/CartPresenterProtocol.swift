import Foundation

protocol CartPresenterProtocol: AnyObject {
    var visibleNFT: [CartNFTModel] { get }
    
    func sortByPrice()
    func sortByRating()
    func sortByName()
    func deleteItemFormCart(for index: Int)
}
