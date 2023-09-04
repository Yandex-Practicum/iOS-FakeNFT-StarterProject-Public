import UIKit

struct CurrencyModel: Equatable {
    let id: String
    let title: String
    let name: String
    let image: UIImage
    
    init(id: String, title: String, name: String, image: UIImage) {
        self.id = id
        self.title = title
        self.name = name
        self.image = image
    }
}
