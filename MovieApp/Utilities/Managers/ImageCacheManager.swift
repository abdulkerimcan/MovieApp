//
//  ImageCacheManager.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 16.03.2024.
//

import UIKit
import Combine

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private var imageCache = NSCache<NSString,UIImage>()
    private var cancellable = Set<AnyCancellable>()
    private init() {}
    
    func loadImage(urlString: String) -> AnyPublisher<UIImage?,Never> {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return Just(cachedImage).eraseToAnyPublisher()
        }
        
        return MovieService.shared.downloadImage(from: urlString)
            .map { data in
                UIImage(data: data)
            }
            .handleEvents(receiveOutput: { [unowned self] image in
                if let image = image {
                    self.imageCache.setObject(image, forKey: urlString as NSString)
                }
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
