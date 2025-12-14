//
//  CoverageItem.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//


import Foundation

struct CoverageItem: Codable, Identifiable {
    let id: String
    let title: String?
    let language: String?
    let thumbnail: Thumbnail
    let mediaType: Int?
    let coverageURL: String?
    let publishedAt: String?
    let publishedBy: String?
    let description: String?
    // other fields omitted for brevity
}

struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]?
    let aspectRatio: Double?
    
    func imageURLString() -> String {
        // per assignment formula
        return "\(domain)/\(basePath)/0/\(key)"
    }
    
    func imageURL() -> URL? {
        URL(string: imageURLString())
    }
}
