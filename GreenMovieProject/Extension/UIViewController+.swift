//
//  UIViewController+.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/5/25.
//

import UIKit
extension UIViewController{
    func goProfileCard(){
        let vc = NicknameUpdateViewController()
        let nav = UINavigationController(rootViewController: vc)

        if let sheet = nav.sheetPresentationController { sheet.prefersGrabberVisible = true }
        
        present(nav, animated: true)
    }
    
    /// 프로필카드를 설정함
    func configureProfileCard(view: ProfileCardView) {
        view.configureData(
            nickname: UserInfoManager.shared.readNickname() ?? "",
            joinDate: "\(UserInfoManager.shared.readFormattedJoinDate()) 가입",
            boxNum: HeartManager.shared.readHeartCount()
        )
    }
}

