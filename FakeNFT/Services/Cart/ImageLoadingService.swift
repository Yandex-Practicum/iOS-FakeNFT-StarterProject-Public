//
//  ImageLoadingService.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import UIKit.UIImage

public protocol ImageLoadingServiceProtocol {
    func fetchImage(url: URL?, completion: @escaping ResultHandler<UIImage>)
}

final class ImageLoadingService: ImageLoadingServiceProtocol {
    enum ImageLoadingError: Error {
        case invalidURL
        case loadingError
    }

    func fetchImage(url: URL?, completion: @escaping ResultHandler<UIImage>) {
        guard let url = url else {
            completion(.failure(ImageLoadingError.invalidURL))
            return
        }

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    completion(.failure(ImageLoadingError.loadingError))
                    return
                }
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
