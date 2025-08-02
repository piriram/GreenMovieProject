//
//  NicknameManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation

final class UserInfoManager {
    static let shared = UserInfoManager()
    
    let nicknameKey = "nickname"
    let joinDateKey = "joinDate"
    let userDefaults = UserDefaultsManager.shared
    
    private init() {}
    
    func createNickname(_ nickname: String) {
        userDefaults.addStrings([nickname], forKey: nicknameKey)
    }
    
    func readNickname() -> String? {
        return userDefaults.getStrings(forKey: nicknameKey).first
    }
    
    func deleteNickname() {
        userDefaults.removeKey(forKey: nicknameKey)
    }
    
    func saveJoinDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        userDefaults.addStrings([dateString], forKey: joinDateKey)
    }
    
    func readJoinDate() -> String? {
        return userDefaults.getStrings(forKey: joinDateKey).first
    }
    func formattedJoinDate() -> String {
        guard let dateStr = readJoinDate() else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateStr) {
            formatter.dateFormat = "yy.MM.dd"
            return formatter.string(from: date) + " 가입"
        }
        return ""
    }
}
