import UIKit.UIImage
import FakeNFT

final class ImageLoadingServiceSpy: ImageLoadingServiceProtocol {
    func fetchImage(
        url: URL?,
        completion: @escaping FakeNFT.ResultHandler<UIImage>
    ) {
        completion(.success(UIImage()))
    }
}
