//
//  NicknameManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation

final class NicknameManager {
    static let shared = NicknameManager()
    
    private let key = "nickname"
    private let userDefaults = UserDefaultsManager.shared
    
    private init() {}

    func createNickname(_ nickname: String) {
        userDefaults.addStrings([nickname], forKey: key)
    }

    func readNickname() -> String? {
        return userDefaults.getStrings(forKey: key).first
    }

    func deleteNickname() {
        userDefaults.removeKey(forKey: key)
    }

    func isExist() -> Bool {
        return readNickname() != nil
    }
}

