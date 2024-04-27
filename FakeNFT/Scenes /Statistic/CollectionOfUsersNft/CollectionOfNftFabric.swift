import Foundation

//MARK: - CollectionOfNftFabric
final class CollectionOfNftFabric {
    
    private var nfts: [String]
    private var nftsFromNetwork: [NftModel] = []
    private var nftNetworkService: NftNetworkService
    
    init(
        with nfts: [String]?,
        servicesAssembly: ServicesAssembly
    ) {
        print("FABRIC START")
        self.nftNetworkService = servicesAssembly.nftNetworkService
        guard let nfts = nfts else {
            self.nfts = []
            return
        }
        self.nfts = nfts
        setNftsFromNetwork()
    }
    
    func isEmpty() -> Bool {
        
        return nfts.isEmpty
    }
    
    func getNftsCount() -> Int {
        
        nfts.count
    }
    
    func getNft(by index: Int) -> NftModel {
//        return nftsFromNetwork[index]
        print(nftsFromNetwork)
        return MockData.shared.placeholderNft
    }
    
    func setNftsFromNetwork() {
        for nftId in nfts {
            DispatchQueue.main.async {
                self.getNftFromNetwork(with: nftId)
                print("3")
            }
        }
    }
    
    func getNftFromNetwork(with id: String) {
        print("KEK")
        DispatchQueue.global(qos: .userInitiated).sync {
            nftNetworkService.loadNft(by: id) { [weak self] result in
                switch result {
                case .success(let nftFromNetwork):
                    print("2")
                    self?.nftsFromNetwork.append(nftFromNetwork)
                    print(self?.nftsFromNetwork.count)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
