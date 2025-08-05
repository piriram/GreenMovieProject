//
//  NotificationHelper.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/5/25.
//

import Foundation

enum NotificationHelper {
    static let updateNickname = Notification.Name("updateNickname")
    static let updateHeart = Notification.Name("updateHeart")
    static let updateRecentKeyword = Notification.Name("updateRecentKeyword")
    
    ///알림 보내기
    static func post(_ name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }
    ///알림 받기
    static func addObserver(_ observer: Any,
                            selector: Selector,
                            name: Notification.Name,
                            object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
    
    ///옵저버 제거
    static func removeObserver(_ observer: Any, name: Notification.Name) {
        NotificationCenter.default.removeObserver(observer, name: name, object: nil)
    }
    ///옴저버 모두 제거
    static func removeAllObservers(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
