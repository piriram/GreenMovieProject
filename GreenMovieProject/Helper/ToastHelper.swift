//
//  ToastHelper.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/5/25.
//

import UIKit
import Toast

final class ToastHelper {
    static func centerToast(view:UIView,message:String){
        var style = ToastStyle()
        style.backgroundColor = .white
        style.messageColor = .black
        view.makeToast(message,duration:2.0,position:.center,style: style)
    }
}
