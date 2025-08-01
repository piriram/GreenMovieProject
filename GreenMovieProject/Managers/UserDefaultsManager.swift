//
//  UserDefaultsManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let standard = UserDefaults.standard
    
    private init() {}
    
    func addStrings(_ value: [String], forKey key: String) {
        standard.set(value, forKey: key)
    }
    
    func getStrings(forKey key: String) -> [String] {
        return standard.stringArray(forKey: key) ?? [] // 옵셔널을 반환
    }
    
    func removeKey(forKey key: String) {
        standard.removeObject(forKey: key)
    }
}

