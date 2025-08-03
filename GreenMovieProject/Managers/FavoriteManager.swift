//
//  FavoriteManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/3/25.
//

import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    private let key = "heart"
    
    private init() {}
    
    func createHeart(id: Int) {
        var ids = readHeartAll()
        if !ids.contains(id){
            ids.append(id)
            UserDefaults.standard.set(ids, forKey: key)
        }
    }
    
    func deleteHeart(id: Int) {
        var ids = readHeartAll()
        ids.removeAll { $0 == id }
        UserDefaults.standard.set(ids, forKey: key)
    }
    
    func readHeartAll() -> [Int] {
        return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }
    
    func isHearted(id: Int) -> Bool {
        return readHeartAll().contains(id)
    }
}
