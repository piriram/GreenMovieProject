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
    let iso639_1: String?
    let filePath: String
    let voteAverage: Double
    let voteCount: Int
    let width: Int

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}


