//
//  CastCell.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/3/25.
//

import UIKit
import SnapKit
import Kingfisher

final class CastCell: UITableViewCell {
    static let identifier = "CastCell"
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let characterLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 16)
        
        characterLabel.textColor = .lightGray
        characterLabel.font = .systemFont(ofSize: 14)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(12)
            $0.right.equalToSuperview().offset(-12)
        }
        
        characterLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.left.right.equalTo(nameLabel)
        }
    }
    
    func configure(with cast: Cast) {
        if let path = cast.profilePath {
            let url = URL(string: "https://image.tmdb.org/t/p/w185\(path)")
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }
        
        nameLabel.text = cast.name
        characterLabel.text = cast.character
    }
}

