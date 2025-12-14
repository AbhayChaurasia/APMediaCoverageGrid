//
//  ImageCellViewModel.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//


import SwiftUI
import UIKit

final class ImageCellViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var url: URL
    private var isCancelled = false
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        // If already loaded in memory cache return quickly
        if let cached = MemoryImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cached
            return
        }
        
        isLoading = true
        errorMessage = nil
        ImageDownloader.shared.loadImage(from: url) { [weak self] result in
            guard let self = self, !self.isCancelled else { return }
            self.isLoading = false
            switch result {
            case .success(let img):
                self.image = img
            case .failure(let err):
                self.errorMessage = err.localizedDescription
            }
        }
    }
    
    func cancel() {
        isCancelled = true
        ImageDownloader.shared.cancelLoad(for: url)
    }
}
