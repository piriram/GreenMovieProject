//
//  NicknameManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Foundation
/// 사용자 정보를 관리하는 매니저입니다.
/// 현재는 닉네임과 가입일자만 사용하고 있습니다.
///
//TODO: 포메터 객체 만들어서 사용해보기 -> 한번만 사용하므로 다음번에,,,
final class UserInfoManager {
    static let shared = UserInfoManager()
    
    let nicknameKey = "nickname"
    let joinDateKey = "joinDate"
    
    private init() {}
    /// 유저디폴트에선 create와 update가 동일하게 작동함
    func createNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname,forKey: nicknameKey)
    }
    
    func readNickname() -> String? {
        return UserDefaults.standard.string(forKey: nicknameKey)
    }
    
    func deleteNickname() {
        UserDefaults.standard.removeObject(forKey:nicknameKey)
    }
    
    func createJoinDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        let dateString = formatter.string(from: date)
        UserDefaults.standard.set(dateString, forKey: joinDateKey)
        
    }
    
    func createUserInfo(_ nickname: String, _ date: Date) {
        createNickname(nickname)
        createJoinDate(date)
    }
    
    func readJoinDate() -> String? {
        return UserDefaults.standard.string(forKey: joinDateKey)
    }
    
    func readFormattedJoinDate() -> String {
        guard let dateStr = readJoinDate() else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        return dateStr
    }
    
    func deleteJoinDate() {
        UserDefaults.standard.removeObject(forKey: joinDateKey)
    }
    
    func hasJoinDate() -> Bool {
        return UserDefaults.standard.string(forKey: joinDateKey) != nil
    }
    
    func hasNickname() -> Bool {
        return UserDefaults.standard.string(forKey: nicknameKey) != nil
    }
    
    func isUserInfo() -> Bool {
        let result = hasJoinDate() && hasNickname()
        return result
    }
    
    func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey:nicknameKey)
        UserDefaults.standard.removeObject(forKey: joinDateKey)
    }
}
