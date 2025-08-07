//
//  EmptyMessageView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/5/25.
//

import UIKit
import SnapKit

final class EmptyMessageView: UIView {
    
    private let messageLabel = UILabel()
    
    init(message: String) {
        super.init(frame: .zero)
        configureUI()
        configureData(message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .clear
        addSubview(messageLabel)
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .lightGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureData(_ text: String) { messageLabel.text = text }
    
    func hide() { isHidden = true}
    
    func show() { isHidden = false }
}
