//
//  FavoriteManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/3/25.
//

import Foundation
/// 사용자의 좋아요 배열을 관리하는 매니저
final class HeartManager {
    static let shared = HeartManager()
    private let key = "heart"
    
    private init() {}
    
    func createHeart(id: Int) {
        var ids = readHeartAll()
        if !ids.contains(id){
            ids.append(id)
            UserDefaults.standard.set(ids, forKey: key)
        }
    }
    func readHeartCount() -> Int {
        return readHeartAll().count
    }
    
    func readHeartAll() -> [Int] {
        return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }
    
    func deleteHeart(id: Int) {
        var ids = readHeartAll()
        ids.removeAll { $0 == id }
        UserDefaults.standard.set(ids, forKey: key)
    }
    
    func deleteAllHeart() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func hasHearted(id: Int) -> Bool {
        return readHeartAll().contains(id)
    }
}
