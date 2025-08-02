//
//  ProfileCardView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/2/25.
//

import UIKit
import SnapKit

final class ProfileCardView: UIView {
    
    let nicknameLabel = UILabel()
    let joinLabel = UILabel()
    let movieBoxButton = UIButton()
    let chevronImage = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        backgroundColor = .darkGray
        layer.cornerRadius = 12
        
        nicknameLabel.textColor = .white
        nicknameLabel.font = .boldSystemFont(ofSize: 18)
        
        joinLabel.textColor = .systemGray4
        chevronImage.tintColor = .systemGray4
        joinLabel.font = .systemFont(ofSize: 12)
        
        movieBoxButton.setTitleColor(.white, for: .normal)
        movieBoxButton.titleLabel?.font = .systemFont(ofSize: 14,weight: .bold)
        movieBoxButton.backgroundColor = .box
        movieBoxButton.titleLabel?.textAlignment = .center
        movieBoxButton.layer.cornerRadius = 8
        
       
        
        addSubview(nicknameLabel)
        addSubview(joinLabel)
        addSubview(movieBoxButton)
        addSubview(chevronImage)
    }
    
    private func configureLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        chevronImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(16)
        }
        joinLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalTo(chevronImage.snp.leading).offset(-8)
        }
        
        movieBoxButton.snp.makeConstraints {
            
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(36)
            
        }
        
       
    }
    
    func configure(nickname: String, joinDate: String, boxNum:Int) {
        nicknameLabel.text = nickname
        joinLabel.text = joinDate
        movieBoxButton.setTitle("\(boxNum)개의 무비박스 보관중", for: .normal)
    }
}

