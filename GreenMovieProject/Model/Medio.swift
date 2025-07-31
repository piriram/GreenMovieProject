//
//  Medio.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import Foundation

struct ImageResponse: Decodable {
    let id: Int
    let backdrops: [MediaImage]
    let logos: [MediaImage]
    let posters: [MediaImage]
}

struct MediaImage: Decodable {
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


