//
//  CastCell.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/4/25.
//
import UIKit
import SnapKit
import Kingfisher

final class CastCell: UIView {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let characterLabel = UILabel()
    
    init(cast: Cast) {
        super.init(frame: .zero)
        configureUI()
        configureDataCell(cast)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        profileImageView.layer.cornerRadius = 24
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 14)
        
        characterLabel.textColor = .lightGray
        characterLabel.font = .systemFont(ofSize: 14)
        characterLabel.numberOfLines = 2
        characterLabel.lineBreakMode = .byTruncatingTail
    }
    
    func configureDataCell(_ cast: Cast) {
        if let path = cast.profilePath {
            let url = URL(string: NetworkManager.shared.composeURLPath(path: path))
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }
        
        nameLabel.text = cast.name
        characterLabel.text = cast.character
    }
    
    func configureLayout() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(characterLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.height.equalTo(52)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
        }
        
       
    }
    
}
