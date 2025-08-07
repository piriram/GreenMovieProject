//
//  RecentSearchManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation
/// 최근 검색 기록을 관리하는 매니저입니다.
/// CRD만 사용하므로 Update는 구현하지 않았음
final class RecentSearchManager {
    static let shared = RecentSearchManager()
    
    let key = "resent_search"
    
    init() {}
    
    func readKeywords() -> [String] {
        return UserDefaults.standard.array(forKey: key) as? [String] ?? []
    }
    
    func createKeyword(_ keyword: String) {
        var current = readKeywords()
        current.removeAll { $0 == keyword }
        current.insert(keyword,at: 0) // 매번 array의 맨앞에 넣는다. 하나씩 다 밀리기 때문에 O(n)의 시간이 걸림
        // 그렇다고 읽기시점에 매번 reverse를 쓰면 쓸때는 append(1)의 비용이지만 읽기 시점에 비용이 발생한다.
        
        UserDefaults.standard.set(current, forKey: key)
        
    }
    
    func deleteOneKeyword(_ keyword: String) {
        let filtered = readKeywords().filter { $0 != keyword }
        UserDefaults.standard.set(filtered, forKey: key)// 배열에서 해당 요소를 제거해서 유저디폴트에 통째로 배열로 넣음
    }
    
    func deleteAllKeyword() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

