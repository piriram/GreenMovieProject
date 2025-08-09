//
//  GenreManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/5/25.
//

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
    
    //TODO: 반환 개수를 파라미터로 받기
    /// 주어진 genreIDs에서 매칭된 이름 최대 2개 반환
    func topGenreNames(from genreIDs: [Int],limit:Int) -> [String] {
        return genreIDs
            .compactMap { genreMap[$0] }
            .prefix(2)
            .map { $0 }
    }
}
