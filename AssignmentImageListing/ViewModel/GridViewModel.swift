//
//  GridViewModel.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//


import Foundation
import Combine
 
@MainActor
final class GridViewModel: ObservableObject {
    
    @Published var items: [CoverageItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchCoverages() {
        guard items.isEmpty else { return }
        isLoading = true
        
        APIService.shared.fetchCoverages(limit: 100) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.items = data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
