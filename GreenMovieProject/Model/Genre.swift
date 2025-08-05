//
//  Genre.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation
import Alamofire
struct GenreListResponse: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

