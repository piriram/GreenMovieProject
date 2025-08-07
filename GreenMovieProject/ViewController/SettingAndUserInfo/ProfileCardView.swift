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
    
    func configureUI() {
        addSubview(nicknameLabel)
        addSubview(joinLabel)
        addSubview(movieBoxButton)
        addSubview(chevronImage)
        
        backgroundColor = .darkGray
        layer.cornerRadius = 12
        
        nicknameLabel.textColor = .white
        nicknameLabel.font = .boldSystemFont(ofSize: 18)
        
        joinLabel.textColor = .systemGray4
        
        joinLabel.font = .systemFont(ofSize: 12)
        
        chevronImage.tintColor = .systemGray4
        
        movieBoxButton.setTitleColor(.white, for: .normal)
        movieBoxButton.titleLabel?.font = .systemFont(ofSize: 14,weight: .bold)
        movieBoxButton.backgroundColor = .box
        movieBoxButton.titleLabel?.textAlignment = .center
        movieBoxButton.layer.cornerRadius = 8
        
    }
    
    func configureLayout() {
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        chevronImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(16)
        }
        
        joinLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalTo(chevronImage.snp.leading).offset(-8)
        }
        
        movieBoxButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
    }
    
    func configureData(nickname: String, joinDate: String, boxNum:Int) {
        nicknameLabel.text = nickname
        joinLabel.text = joinDate
        movieBoxButton.setTitle("\(boxNum)개의 무비박스 보관중", for: .normal)
    }
}

