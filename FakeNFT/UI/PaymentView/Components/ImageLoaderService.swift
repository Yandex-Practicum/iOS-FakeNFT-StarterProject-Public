//
//  ImageLoaderService.swift
//  FakeNFT
//
//  Created by Сергей Петров on 23.07.2026.
//

import UIKit
import os

final class ImageLoaderService {
    
    static let shared = ImageLoaderService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from urlString: String) async -> UIImage? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            let image = UIImage(named: urlString)
            if let image = image {
                cache.setObject(image, forKey: urlString as NSString)
            }
            return image
        }
        
        guard let url = URL(string: urlString) else {
            os_log(.error, log: .default, "ImageLoader: Invalid URL string: %{public}@", urlString)
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            
            cache.setObject(image, forKey: urlString as NSString)
            return image
            
        } catch {
            os_log(.error, log: .default, "ImageLoader: Failed to load image from %{public}@: %{public}@", urlString, error.localizedDescription)
            return nil
        }
    }
}
