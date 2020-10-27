//
//  ImageCache.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/27/20.
//

import UIKit

public final class ImageCache {

    /// First level cache, that contains encoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    /// Second level cache, that contains decoded images
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Configuration

    init(config: Configuration = Configuration.default) {
        self.config = config
    }
    
}

extension ImageCache: ImageCacheable {
    
    public func removeAllImages() {
        decodedImageCache.removeAllObjects()
        imageCache.removeAllObjects()
    }
    
    public func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decodedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(decodedImage, forKey: url as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
    }

    public func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
    
    public func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        // search for image data
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
            return decodedImage
        }
        return nil
    }
    
    public subscript(_ key: URL) -> UIImage? {
        get {
            image(for: key)
        }
        set {
            insertImage(newValue, for: key)
        }
    }
    
}

extension ImageCache {
    
    public struct Configuration {
        let countLimit: Int
        let memoryLimit: Int

        static let `default` = Configuration(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }
    
}

public final class ImageLoader {

    private let cache = ImageCache()
    
    public static let shared = ImageLoader()
    
    /// Loads an image using the given url from cache if it's cached. Otherwise it downloads the data, returns UIImage and caches it.
    /// - Parameters:
    ///   - url: URL of the image
    ///   - completion: Completion handler
    public func loadImage(from url: URL, completion: ((UIImage?, Error?) -> Void)?) {
        if let image = cache[url] {
            completion?(image, nil)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            if let error = error {
                completion?(nil, error)
            } else if let data = data, let image = UIImage(data: data) {
                self?.cache[url] = image
                DispatchQueue.main.async {
                    completion?(image, nil)
                }
            }
        }).resume()
    }
    
}

public extension UIImageView {
    
    /// Sets the image using given url from cache if it's cached. Otherwise, downloads the data, caches image and sets it. Placeholder image is set before loading the image.
    /// - Parameters:
    ///   - url: URL of the image
    ///   - placeholderImage: Image used if loading fails.
    ///   - completion: Completion handler
    func setImage(from url: URL, placeholderImage: UIImage? = nil, completion: ((Error?) -> Void)? = nil) {
        image = placeholderImage
        ImageLoader.shared.loadImage(from: url) { [weak self] image, error in
            if let image = image {
                self?.image = image
            }
            completion?(error)
        }
    }
    
}
