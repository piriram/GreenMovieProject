//
//  Movie.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let overview: String
    let genreIds: [Int]
    var isHearted: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case overview
        case genreIds = "genre_ids"
    }
}
