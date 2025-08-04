//
//  CastView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/3/25.
//
import UIKit
import Kingfisher

final class CastListView: UIView {
    
    var cast: [Cast] = []
    
    let stackView = UIStackView()
    
    init(cast: [Cast]) {
        super.init(frame: .zero)
        self.cast = Array(cast.prefix(5))
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        addSubview(stackView)
        
        for item in cast {
            let view = createItemView(cast: item)
            stackView.addArrangedSubview(view)
        }
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func createItemView(cast: Cast) -> UIView {
        let profileImageView = UIImageView()
        profileImageView.layer.cornerRadius = 24
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.snp.makeConstraints { $0.size.equalTo(48) }
        
        if let path = cast.profilePath {
            let url = URL(string: NetworkManager.shared.composeURLPath(path: path))
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }
        
        let nameLabel = UILabel()
        nameLabel.text = cast.name
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 14)
        
        let characterLabel = UILabel()
        characterLabel.text = cast.character
        characterLabel.textColor = .lightGray
        characterLabel.font = .systemFont(ofSize: 12)
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, characterLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        
        let hStack = UIStackView(arrangedSubviews: [profileImageView, textStack])
        hStack.axis = .horizontal
        hStack.spacing = 12
        return hStack
    }
}
