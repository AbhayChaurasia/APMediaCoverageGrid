//
//  DiskImageCache.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//


import UIKit
import CryptoKit

final class DiskImageCache {
    static let shared = DiskImageCache()
    private let ioQueue = DispatchQueue(label: "disk.image.cache.queue")
    private let directoryURL: URL
    
    private init() {
        let fm = FileManager.default
        if let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first {
            directoryURL = caches.appendingPathComponent("ImageGridCache", isDirectory: true)
        } else {
            directoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ImageGridCache", isDirectory: true)
        }
        try? fm.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }
    
    private func fileURL(forKey key: String) -> URL {
        // create filename as SHA256 of key (URL string)
        let hashed = sha256(key)
        return directoryURL.appendingPathComponent("\(hashed).dat")
    }
    
    private func sha256(_ string: String) -> String {
        let data = Data(string.utf8)
        let digest = SHA256.hash(data: data)
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func write(data: Data, forKey key: String) {
        let dest = fileURL(forKey: key)
        ioQueue.async {
            do {
                try data.write(to: dest, options: .atomic)
            } catch {
                // Could log failure
            }
        }
    }
    
    func read(forKey key: String, completion: @escaping (Data?) -> Void) {
        let src = fileURL(forKey: key)
        ioQueue.async {
            let data = try? Data(contentsOf: src)
            completion(data)
        }
    }
    
    func exists(forKey key: String) -> Bool {
        FileManager.default.fileExists(atPath: fileURL(forKey: key).path)
    }
    
    func clear() {
        ioQueue.async {
            try? FileManager.default.removeItem(at: self.directoryURL)
            try? FileManager.default.createDirectory(at: self.directoryURL, withIntermediateDirectories: true)
        }
    }
}
