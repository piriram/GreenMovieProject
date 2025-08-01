//
//  Medio.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import Foundation

struct MedioResponse: Decodable {
    let id: Int
    let backdrops: [Medio]
    let logos: [Medio]
    let posters: [Medio]
}

struct Medio: Decodable {
    let aspectRatio: Double
    let height: Int
    let filePath: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case filePath = "file_path"
        case width
    }
}


