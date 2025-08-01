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
        configureAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAll(){
        
        configureUI()
        configureLayout()
        
    }
    func configureUI(){
        
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
    func configureLayout(){
        
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            //            make.height.equalTo(300) //TODO: 세로길이에 맞춰서 늘어나기
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
    }
    
    func configureData(){
        
        
    }
    
    func configureCell(_ movie: Trending){
        //        print(movie.title)
        
        
        let urlString = NetworkManager.shared.composeURLPath(path: movie.posterPath)
        let url = URL(string: urlString)!
        posterImageView.kf.setImage(with: url)
        
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
    }
    
}

