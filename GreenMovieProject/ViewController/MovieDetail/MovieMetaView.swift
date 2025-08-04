//
//  MovieMetaView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import SnapKit

final class MovieMetaView: UIView {
    
    let releaseDateIcon = UIImageView(image: UIImage(systemName: "calendar"))
    let releaseDateLabel = UILabel()
    
    let ratingIcon = UIImageView(image: UIImage(systemName: "star.fill"))
    let ratingLabel = UILabel()
    
    let genreIcon = UIImageView(image: UIImage(systemName: "film"))
    let genreLabel = UILabel()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            makeItemStack(icon: releaseDateIcon, label: releaseDateLabel),
            separatorView(),
            makeItemStack(icon: ratingIcon, label: ratingLabel),
            separatorView(),
            makeItemStack(icon: genreIcon, label: genreLabel)
        ])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [releaseDateLabel, ratingLabel, genreLabel].forEach {
            $0.font = .systemFont(ofSize: 13)
            $0.textColor = .lightGray
        }
        
        [releaseDateIcon, ratingIcon, genreIcon].forEach {
            $0.tintColor = .lightGray
            $0.contentMode = .scaleAspectFit
            $0.snp.makeConstraints { $0.size.equalTo(14) }
        }
        
        addSubview(stackView)
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func makeItemStack(icon: UIImageView, label: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }
    
    func separatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.snp.makeConstraints { $0.width.equalTo(1); $0.height.equalTo(14) }
        return view
    }
    
    func configureData(releaseDate: String, rating: Double, genre: String) {
        releaseDateLabel.text = releaseDate
        ratingLabel.text = String(format: "%.1f", rating)
        genreLabel.text = genre
    }
}
