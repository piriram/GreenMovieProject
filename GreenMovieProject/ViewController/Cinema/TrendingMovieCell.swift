//
//  TrendingMovieCell.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import SnapKit
import Kingfisher

class TrendingMovieCell: UICollectionViewCell {
    static let identifier = "TrendingMovieCell"
    
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 20
        
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        overviewLabel.textColor = .name
        overviewLabel.font = .systemFont(ofSize: 12)
        overviewLabel.numberOfLines = 3
    }
    
    func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview()
        }

        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(4)
        }

        // Poster Image View: 남은 공간 모두 차지
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
    }

    
    func configureCell(_ movie: Trending) {
        let urlString = NetworkManager.shared.composeURLPath(path: movie.posterPath)
        if let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
    }
}
