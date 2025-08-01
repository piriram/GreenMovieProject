//
//  PaddingLabel.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit

final class PaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)

    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
