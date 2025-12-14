//
//  APIService.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//


import Foundation

import Foundation

final class APIService {
    
    static let shared = APIService()
    private init() {}
    
    private let baseURL =
    "https://acharyaprashant.org/api/v2/content/misc/media-coverages"
    
    func fetchCoverages(
        limit: Int = 100,
        completion: @escaping (Result<[CoverageItem], Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)?limit=\(limit)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode([CoverageItem].self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
