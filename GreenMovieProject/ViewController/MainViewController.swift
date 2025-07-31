//
//  MainViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit

final class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTabBar()
    }
    
    private func setupTabBar() {
        let cinemaVC = UINavigationController(rootViewController: CinemaViewController())
        cinemaVC.tabBarItem = UITabBarItem(title: "CINEMA", image: UIImage(systemName: "popcorn"), selectedImage: UIImage(systemName: "popcorn.fill"))
        
        let upcomingVC = UINavigationController(rootViewController: ViewController())
        upcomingVC.tabBarItem = UITabBarItem(title: "UPCOMING", image: UIImage(systemName: "film"), selectedImage: UIImage(systemName: "film.fill"))
        
        let profileVC = UINavigationController(rootViewController: ViewController())
        profileVC.tabBarItem = UITabBarItem(title: "PROFILE", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        viewControllers = [cinemaVC, upcomingVC, profileVC]
        
        // 탭바 색상 설정
        tabBar.barTintColor = .black
        tabBar.tintColor = .primary
        tabBar.unselectedItemTintColor = .lightGray
    }
}
