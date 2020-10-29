//
//  ImageLoader.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/27/20.
//

import UIKit

public final class ImageLoader: Cacheable {
    
    public enum CacheType {
        case inMemory, disk
    }

    private var cache = Cache<URL, Data>()
    /// Cache type. If it's `.inMemory`, it only saves in RAM. If `.disk`, then it saves it in RAM and persists it on disk when app will resign active.
    public var cacheType: CacheType = .disk
    
    public static let shared = ImageLoader()
    private init() {
        do {
            cache = try Cache<URL, Data>.loadFromDisk(withName: cacheName)
        } catch {
            print(error.localizedDescription)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveToDiskIfNeeded), name: UIScene.willDeactivateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveToDiskIfNeeded), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    deinit {
        saveToDiskIfNeeded()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func saveToDiskIfNeeded() {
        guard cacheType == .disk else { return }
        do {
            try cache.saveToDisk(withName: cacheName)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Loads an image using the given url from cache if it's cached. Otherwise it downloads the data, returns UIImage and caches it.
    /// - Parameters:
    ///   - url: URL of the image
    ///   - completion: Completion handler
    public func loadImage(from url: URL, completion: ((UIImage?, Error?) -> Void)?) {
        if let data = cache[url] {
            completion?(UIImage(data: data), nil)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            if let error = error {
                completion?(nil, error)
            } else if let data = data, let image = UIImage(data: data) {
                self?.cache[url] = data
                DispatchQueue.main.async {
                    completion?(image, nil)
                }
            }
        }).resume()
    }
    
    public func clearInMemoryCache() {
        cache.removeAll()
    }
    
    public func deleteOnDiskCache() {
        do {
            try cache.removeFromDisk(withName: cacheName)
        } catch {
            print(error.localizedDescription)
        }
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
