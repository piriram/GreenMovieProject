//
//  UIBarButtonItem+.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/5/25.
//
import UIKit

extension UIBarButtonItem {
    static func actionBackBarButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let backButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: target,
            action: action
        )
        backButtonItem.tintColor = .primary
        return backButtonItem
    }
}
