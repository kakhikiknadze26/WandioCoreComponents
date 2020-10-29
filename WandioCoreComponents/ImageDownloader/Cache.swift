//
//  Cache.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/27/20.
//

import Foundation

public protocol Cacheable {
    var cacheName: String { get }
}

public extension Cacheable {
    var cacheName: String { String(describing: self) }
}

public final class Cache<Key: Hashable, Value> {
    
    private let cache = NSCache<CacheKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()
    
    public init(dateProvider: @escaping () -> Date = Date.init, entryLifetime: TimeInterval = 12 * 60 * 60, maximumEntryCount: Int = 50) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        cache.countLimit = maximumEntryCount
        cache.delegate = keyTracker
    }
    
    public func insert(_ value: Value, forKey key: Key) {
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
        insert(entry)
    }

    public func value(forKey key: Key) -> Value? {
        entry(forKey: key)?.value
    }

    public func removeValue(forKey key: Key) {
        cache.removeObject(forKey: CacheKey(key))
    }
    
    public func removeAll() {
        cache.removeAllObjects()
    }
    
    public subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
    
}

private extension Cache {
    
    final class CacheKey: NSObject {
        
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? CacheKey else {
                return false
            }
            return value.key == key
        }
        
    }
    
}

private extension Cache {
    
    final class Entry {
        
        let key: Key
        let value: Value
        let expirationDate: Date

        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
        
    }
    
}

private extension Cache {
    
    final class KeyTracker: NSObject, NSCacheDelegate {
        
        var keys = Set<Key>()

        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject object: Any) {
            guard let entry = object as? Entry else { return }
            keys.remove(entry.key)
        }
        
    }
    
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}

extension Cache: Codable where Key: Codable, Value: Codable {
    
    public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(insert)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
    
}

public extension Cache where Key: Codable, Value: Codable {
    
    func saveToDisk(withName name: String, using fileManager: FileManager = .default) throws {
        guard let fileURL = makeURL(withName: name, using: fileManager) else { throw Error.invalidDirectory }
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
    
    static func loadFromDisk(withName name: String, using fileManager: FileManager = .default) throws -> Self {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name + ".cache") else { throw Error.invalidDirectory }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
    func removeFromDisk(withName name: String, using fileManager: FileManager = .default) throws {
        guard let url = makeURL(withName: name, using: fileManager) else { throw Error.invalidDirectory }
        try fileManager.removeItem(at: url)
    }
    
    private func makeURL(withName name: String, using fileManager: FileManager = .default) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(name + ".cache")
    }
    
}

private extension Cache {
    
    func entry(forKey key: Key) -> Entry? {
        guard let entry = cache.object(forKey: CacheKey(key)) else { return nil }
        guard dateProvider() < entry.expirationDate else { removeValue(forKey: key); return nil }
        return entry
    }

    func insert(_ entry: Entry) {
        cache.setObject(entry, forKey: CacheKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
    
}

public extension Cache {
    
    enum Error: Swift.Error {
        case invalidDirectory
        case fileAlreadyExists
        case fileNotExists
    }
    
}
