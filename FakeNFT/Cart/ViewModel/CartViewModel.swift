import UIKit

final class CartViewModel {
    @Observable
    var NFTModels: [NFTModel] = []
    
    private let model: CartLoadModel
    
    init(model: CartLoadModel) {
        self.model = model
    }
    
    func didLoad() {
        model.fetchNft { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                switch result {
                case let .success(models):
                    let viewModelModels = models.map(NFTModel.init(model:))
                    self.NFTModels = viewModelModels
                    print(self.NFTModels)
                    print("IM HERE TOO")
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
