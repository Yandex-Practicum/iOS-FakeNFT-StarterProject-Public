import Foundation

struct CartScreenModel {
    let items: [CartItemModel]
    let itemsCount: Int
    
    var totalPrice: Double {
        var price: Double = 0
        items.forEach {
            price += $0.price
        }
        return price
    }
    
    init(items: [CartItemModel]) {
        self.items = items
        self.itemsCount = items.count
    }
}
