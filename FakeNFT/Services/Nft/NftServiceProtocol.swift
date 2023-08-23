protocol NftServiceProtocol {
    func getNftList(nftIds: [Int], onCompletion: @escaping (Result<[Nft], Error>) -> Void)
    func getNft(nftId: Int, onCompletion: @escaping (Result<Nft, Error>) -> Void)
}
