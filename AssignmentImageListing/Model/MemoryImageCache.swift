//
//  MemoryImageCache.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//


import UIKit

final class MemoryImageCache {
    static let shared = MemoryImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() {
        cache.countLimit = 500 // adjust as needed
        cache.totalCostLimit = 200 * 1024 * 1024 // ~200MB
    }
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    func setImage(_ image: UIImage, forKey key: String) {
        let cost = image.jpegData(compressionQuality: 1)?.count ?? 0
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    func removeAll() {
        cache.removeAllObjects()
    }
}
