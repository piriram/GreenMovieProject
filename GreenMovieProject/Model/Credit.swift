//
//  Credit.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import Foundation
import Foundation

struct CreditsResponse: Decodable {
    let id: Int // 디폴트 0
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Decodable {
    let adult: Bool // 디폴트 true
    let gender: Int // 디폴트 0
    let id: Int // 디폴트 0
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double // 디폴트 0
    let profilePath: String?
    let castId: Int // 디폴트 0
    let character: String
    //    let creditId: String // 가끔 Int로 나옴
    let order: Int // 디폴트 0
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, popularity, character, order
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castId = "cast_id"
        //        case creditId = "credit_id"
    }
}

struct Crew: Decodable {
    let adult: Bool // 디폴트 true
    let gender: Int // 디폴트 0
    let id: Int // 디폴트 0
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double // 디폴트 0
    let profilePath: String?
    //    let creditId: String //
    let department: String
    let job: String
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, popularity,department, job
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
    }
}
