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

        if let sheet = nav.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
}

