import Foundation

struct NFTRequest: NetworkRequest {
  var endpoint: URL?

  init(id: String) {
    guard let endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)") else { return }
    self.endpoint = endpoint
  }
}
