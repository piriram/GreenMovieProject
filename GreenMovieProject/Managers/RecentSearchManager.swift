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
        return UserDefaultsManager.shared.getStrings(forKey: key)
    }
    
    func addKeyword(_ keyword: String) {
        var current = getKeywords()
        current.insert(keyword,at: 0)
        
       
        print("keywords: \(current)")
        UserDefaultsManager.shared.addStrings(current, forKey: key)
    }
    
    func removeKeyword(_ keyword: String) {
        let filtered = getKeywords().filter { $0 != keyword }
        UserDefaultsManager.shared.addStrings(filtered, forKey: key) // 배열을 제거해서 배열로 넣기
    }
    
    func removeAllKeyword() {
        UserDefaultsManager.shared.removeKey(forKey: key)
    }
}

