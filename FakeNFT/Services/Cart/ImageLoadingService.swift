//
//  ImageLoadingService.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import UIKit
import Kingfisher

protocol ImageLoadingServiceProtocol {
    func fetchImage(url: URL?, completion: @escaping ((Result<UIImage, Error>) -> Void))
}

final class ImageLoadingService: ImageLoadingServiceProtocol {
    enum ImageLoadingError: Error {
        case invalidURL
    }

    func fetchImage(url: URL?, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let url = url else {
            completion(.failure(ImageLoadingError.invalidURL))
            return
        }

        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                completion(.success(imageResult.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
