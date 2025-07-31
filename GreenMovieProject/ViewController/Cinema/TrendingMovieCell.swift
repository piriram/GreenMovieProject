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
        print(#function)
        super.init(frame: frame)
        configureAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAll(){
        print(#function)
        configureUI()
        configureLayout()
        
    }
    func configureUI(){
        print(#function)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 20
        
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        overviewLabel.textColor = .name
        overviewLabel.font = .systemFont(ofSize: 15)
        overviewLabel.numberOfLines = 3
        
        
        
    }
    func configureLayout(){
        print(#function)
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(300) //TODO: 세로길이에 맞춰서 늘어나기
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
    }
    
    func configureData(){
        print(#function)
        
    }
    func configureCell(_ movie: Trending){
        print(movie.title)
        print(#function)
        let base = "https://image.tmdb.org/t/p/w500"
        let path = movie.posterPath
        if path != ""{
            let url = URL(string: base + path)!
            posterImageView.kf.setImage(with: url)
        }else{
            posterImageView.image = UIImage(systemName: "photo")
        }
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
    }
}
