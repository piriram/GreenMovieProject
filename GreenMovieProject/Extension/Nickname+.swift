//
//  Nickname+.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/5/25.
//

import UIKit

extension NicknameDetailViewController {
    enum NicknameStatus {
        case shortOrLong
        case containsNumber
        case containsSymbol
        case valid
        
        var result: (message: String, color: UIColor) {
            switch self {
            case .shortOrLong:
                return ("2글자 이상 10글자 미만으로 설정해주세요", .red)
            case .containsNumber:
                return ("닉네임에 숫자는 포함할 수 없어요", .red)
            case .containsSymbol:
                return ("닉네임에 @, #, $, % 는 포함할 수 없어요", .red)
            case .valid:
                return ("사용할 수 있는 닉네임이에요", .primary)
            }
        }
    }
    
}
