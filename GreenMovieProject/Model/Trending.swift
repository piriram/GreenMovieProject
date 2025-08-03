//
//  Trending.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import Foundation
struct TrendingResponse: Decodable {
    let page: Int // 디폴트 0
    let results:[Trending]
    let totalPages: Int // total_pages 디폴트 0
    let totalResults: Int // total_results 디폴트 0
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct Trending: Decodable {
    //    let backdropPath: String //backdrop_path
    
    let id: Int // 디폴트 0
    let title:String
    //    let originalLanguage: String //original_language
    //    let originalTitle: String // original)tutke
    let overview: String
    
    let posterPath:String // poster_path
    
    let genreIds:[Int] //genre_ids
    let releaseDate:String //release_date
    
    let voteAverage:Double //vote_number 디폴트 0
    
    var isHearted: Bool = false
    
    enum CodingKeys: String, CodingKey {
        
        
        case id
        case title
        
        
        case overview
        case posterPath = "poster_path"
        
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        
        case voteAverage = "vote_average"
        
    }
    
}


//struct Trending: Decodable {
//    let adult: Bool
//    let backdropPath: String //backdrop_path
//    
//    let id: Int // 디폴트 0
//    let title:String
//    let originalLanguage: String //original_language
//    let originalTitle: String // original)tutke
//    let overview: String
//    
//    let posterPath:String // poster_path
//    let mediaType:String //media_type
//    let genreIds:[Int] //genre_ids
//    let releaseDate:String //release_date
//    let video:Bool // 디폴트 true
//    let voteAverage:Double //vote_number 디폴트 0
//    let voteCount:Int // vote_count 디폴트 0
//    var isHearted: Bool = false
//    
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case id
//        case title
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview
//        case posterPath = "poster_path"
//        case mediaType = "media_type"
//        case genreIds = "genre_ids"
//        case releaseDate = "release_date"
//        case video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//    
//}
