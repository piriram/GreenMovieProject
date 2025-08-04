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

import Foundation

final class GenreManager {
    
    static let shared = GenreManager()
    private init() {}
    
    var genreMap: [Int: String] = [:]
    private var isLoaded: Bool { !genreMap.isEmpty }
    
    // 최초 1회만 네트워크 요청, 이후 캐싱 사용
    func loadGenresIfNeeded(completion: @escaping () -> Void) {
        guard !isLoaded else {
            completion()
            return
        }
        
        NetworkManager.shared.fetchGenres { [weak self] genreDict in
            self?.genreMap = genreDict
            completion()
        }
    }
    
    /// 주어진 genreIDs에서 매칭된 이름 최대 3개 반환
    func top3GenreNames(from genreIDs: [Int]) -> [String] {
        return genreIDs
            .compactMap { genreMap[$0] }
            .prefix(3)
            .map { $0 }
    }
}
