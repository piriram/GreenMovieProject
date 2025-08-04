//
//  NicknameManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation
//TODO: 포메터 객체 만들어서 사용해보기
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
    func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey:nicknameKey)
        UserDefaults.standard.removeObject(forKey: joinDateKey)
    }
    
    func createJoinDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        let dateString = formatter.string(from: date)
        UserDefaults.standard.set(dateString, forKey: joinDateKey)
    }
    
    func readJoinDate() -> String? {
        return UserDefaults.standard.string(forKey: joinDateKey)
    }
    func getFormattedJoinDate() -> String {
        guard let dateStr = readJoinDate() else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        return dateStr
    }
    func deleteJoinDate() {
        UserDefaults.standard.removeObject(forKey: joinDateKey)
    }
    func isJoinDate() -> Bool {
        return UserDefaults.standard.string(forKey: joinDateKey) != nil
    }
    func isNickname() -> Bool {
        return UserDefaults.standard.string(forKey: nicknameKey) != nil
    }
    
    func isUserInfo() -> Bool {
        let result = isJoinDate() && isNickname()
        
        print("UserInfor가있는지 : \(result)")
        return result
    }
}
