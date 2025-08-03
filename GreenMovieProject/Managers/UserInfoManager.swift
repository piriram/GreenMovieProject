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
    
    private init() {}
    
    func createNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname,forKey: nicknameKey)
    }
    
    func readNickname() -> String? {
        return UserDefaults.standard.string(forKey: nicknameKey)
    }
    
    func deleteNickname() {
        UserDefaults.standard.removeObject(forKey:nicknameKey)
    }
    
    func saveJoinDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        UserDefaults.standard.set(dateString, forKey: joinDateKey)
    }
    
    func readJoinDate() -> String? {
        return UserDefaults.standard.string(forKey: joinDateKey)
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
