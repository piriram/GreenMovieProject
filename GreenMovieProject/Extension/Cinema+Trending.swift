//
//  Cinema+Trending.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
/// 트렌딩 관련 함수들 모아놓기
extension CinemaViewController{
    
    
}

extension UIViewController{
    func goProfileCard(){
        let vc = NicknameUpdateViewController()
        let nav = UINavigationController(rootViewController: vc)

        if let sheet = nav.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)

    }
}
