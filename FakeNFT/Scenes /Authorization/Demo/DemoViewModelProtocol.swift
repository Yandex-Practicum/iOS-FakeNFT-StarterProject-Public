import Foundation

protocol DemoViewModelProtocol: AnyObject {
    var cartNft: Observable<[NFTCard]?> {get}
    var authorName: Observable<String?> {get}
    func additionNFT() -> Int
    func additionPriceNFT() -> Float
    func sortNFT(_ sortOptions: SortingOption)
    func unwrappedCartNftViewModel() -> [NFTCard]
    func unwrappedAuthorViewModel() -> String
}

final class DemoViewModel: DemoViewModelProtocol {
    
    // MARK: constants and variables
    private let dataProvider = DataProvider()
    private var idNfts: [String] = ["1", "2", "3", "4"]
    var cartNft: Observable<[NFTCard]?> {
        $cartNFT
    }
    
    var authorName: Observable<String?> {
        $nameAthor
    }
    
    // MARK: Dependencies
    private var orderID: String?
    private var demoCollection: [NFTCollection] = []
    
    // MARK: Observable constants and variables
    @Observable
    private(set) var cartNFT: [NFTCard]?  = []
    
    @Observable
    private(set) var nameAthor: String?
    
    // MARK: Init
    init() {
        getNfts()
    }
    
    // MARK: Methods
    
    private func getNfts() {
        dataProvider.fetchUsersNFT(userId: nil, nftsId: idNfts) {[weak self ]result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                data.forEach {self.cartNFT?.append($0)}
                self.getUserName()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func getUserName() {
        guard let userId = cartNFT?.first?.id else { return }
        dataProvider.fetchUserID(userId: userId) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.nameAthor = data.name
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func additionNFT() -> Int {
        let cartNFT = unwrappedCartNftViewModel()
        return cartNFT.count
    }
    
    func additionPriceNFT() -> Float {
        let cartNFT = unwrappedCartNftViewModel()
        return Float(cartNFT.reduce(0) {$0 + $1.price})
    }
    
    func sortNFT(_ sortOptions: SortingOption) {
        var newNftCart: [NFTCard] = []
        let cartNFT = unwrappedCartNftViewModel()
        switch sortOptions {
        case .byPrice: newNftCart = cartNFT.sorted(by: {$0.price < $1.price})
        case .byRating: newNftCart = cartNFT.sorted(by: {$0.rating < $1.rating})
        case .byName: newNftCart = cartNFT.sorted(by: {$0.name < $1.name})
        default: break
        }
        self.cartNFT = newNftCart
    }
    
    func unwrappedCartNftViewModel() -> [NFTCard] {
        let cartNFT: [NFTCard] = []
        if let cartNFT = self.cartNft.wrappedValue {
            return cartNFT
        }
        return cartNFT
    }
    
    func unwrappedAuthorViewModel() -> String {
        let author: String = ""
        if let author = self.authorName.wrappedValue {
            return author
        }
        return author
    }
}
