import Foundation

protocol DeleteFromCartViewControllerDelegate: AnyObject {
    func showTabBar()
    func deleteItemFromCart(for index: Int)
}
