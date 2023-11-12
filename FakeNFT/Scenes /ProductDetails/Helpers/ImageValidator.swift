import Foundation
import Kingfisher

protocol ImageValidatorProtocol {
    func isValidImageURL(_ url: URL, completion: @escaping (Bool) -> Void)
}

final class ImageValidator: ImageValidatorProtocol {
    func isValidImageURL(_ url: URL, completion: @escaping (Bool) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
