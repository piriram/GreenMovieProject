//
//  RecentSearchManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation

final class RecentSearchManager {
    static let shared = RecentSearchManager()
    
    let key = "resent_search"
    
    init() {}
    
    func getKeywords() -> [String] {
        return UserDefaults.standard.array(forKey: key) as? [String] ?? []
    }
    
    func addKeyword(_ keyword: String) {
        var current = getKeywords()
        current.removeAll { $0 == keyword }
        current.insert(keyword,at: 0)
        
       
        print("keywords: \(current)")
        UserDefaults.standard.set(current, forKey: key)
        
    }
    
    func removeKeyword(_ keyword: String) {
        let filtered = getKeywords().filter { $0 != keyword }
        UserDefaults.standard.set(filtered, forKey: key)// 배열을 제거해서 배열로 넣음
    }
    
    func removeAllKeyword() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

