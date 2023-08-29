import Foundation

protocol NFTsNetworkClientProtocol {
    func getNFTBy(id: String, completion: @escaping (Result<NFTResponseModel, Error>) -> Void)
    func getAuthorOfNFC(by id: String, completion: @escaping (Result<AuthorResponseModel, Error>) -> Void)
}
