//
//  ImageLoader.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/27/20.
//

import UIKit

public final class ImageLoader: Cacheable {
    
    /// Loads an image using the given url from cache if it's cached. Otherwise it downloads the data, returns UIImage and caches it.
    /// - Parameters:
    ///   - url: URL of the image
    ///   - cachePolicy: Caching policy for request. Default is `.useProtocolCachePolicy`
    ///   - completion: Completion handler
    public func loadImage(from url: URL, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, completion: ((UIImage?, Error?) -> Void)?) {
        let request = URLRequest(url: url, cachePolicy: cachePolicy)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                var image: UIImage? = nil
                if let data = data {
                    image = UIImage(data: data)
                }
                completion?(image, error)
            }
        }).resume()
    }
    
}

public extension UIImageView {
    
    /// Sets the image using given url from cache if it's cached. Otherwise, downloads the data, caches image and sets it. Placeholder image is set before loading the image.
    /// - Parameters:
    ///   - url: URL of the image
    ///   - placeholderImage: Image used if loading fails.
    ///   - cachePolicy: Caching policy for request. Default is `.useProtocolCachePolicy`
    ///   - completion: Completion handler
    func setImage(from url: URL, placeholderImage: UIImage? = nil, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, completion: ((Error?) -> Void)? = nil) {
        image = placeholderImage
        ImageLoader().loadImage(from: url, cachePolicy: cachePolicy) { [weak self] image, error in
            if let image = image {
                self?.image = image
            }
            completion?(error)
        }
    }
    
}
