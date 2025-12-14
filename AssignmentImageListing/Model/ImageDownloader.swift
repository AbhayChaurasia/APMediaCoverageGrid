//
//  ImageDownloader.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//


import UIKit

final class ImageDownloader {
    static let shared = ImageDownloader()
    private init() {}
    
    // Track active data tasks for cancellation
    private var tasks: [URL: URLSessionDataTask] = [:]
    private let tasksQueue = DispatchQueue(label: "image.downloader.tasks", attributes: .concurrent)
    
    // Public load function
    /// Loads image using memory -> disk -> network order. Calls completion on main thread.
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let key = url.absoluteString
        
        // 1. Memory cache
        if let img = MemoryImageCache.shared.image(forKey: key) {
            DispatchQueue.main.async {
                completion(.success(img))
            }
            return
        }
        
        // 2. Disk cache
        DiskImageCache.shared.read(forKey: key) { data in
            if let data = data, let img = UIImage(data: data) {
                // update memory cache
                MemoryImageCache.shared.setImage(img, forKey: key)
                DispatchQueue.main.async {
                    completion(.success(img))
                }
                return
            }
            
            // 3. Network fetch
            self.fetchFromNetwork(url: url, completion: completion)
        }
    }
    
    private func fetchFromNetwork(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // If a task already exists, don't create duplicate - but we may want multiple completions.
        tasksQueue.sync {
            if let existing = tasks[url] {
                // attach additional completion by creating a small wrapper:
                // For simplicity we'll cancel duplicate request and create a new one below.
                existing.cancel()
            }
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, resp, err in
            guard let self = self else { return }
            // remove from tasks
            self.tasksQueue.async(flags: .barrier) {
                self.tasks[url] = nil
            }
            if let err = err {
                DispatchQueue.main.async { completion(.failure(err)) }
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(.failure(URLError(.cannotDecodeContentData))) }
                return
            }
            // write to disk & memory
            DiskImageCache.shared.write(data: data, forKey: url.absoluteString)
            MemoryImageCache.shared.setImage(image, forKey: url.absoluteString)
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        // store and resume
        tasksQueue.async(flags: .barrier) {
            self.tasks[url] = task
        }
        task.resume()
    }
    
    func cancelLoad(for url: URL) {
        tasksQueue.async(flags: .barrier) {
            if let task = self.tasks[url] {
                task.cancel()
                self.tasks[url] = nil
            }
        }
    }
    
    func cancelAll() {
        tasksQueue.async(flags: .barrier) {
            for (_, t) in self.tasks {
                t.cancel()
            }
            self.tasks.removeAll()
        }
    }
}
