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
    let heartButton = UIButton()
    var movieID: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        configureData()
        
        heartButton.addTarget(self, action: #selector(heartButtonTouched), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureData(){
        
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
        overviewLabel.font = .systemFont(ofSize: 14)
        overviewLabel.numberOfLines = 3
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .primary
        contentView.addSubview(heartButton)
       
    }
    
    func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview()
        }
        heartButton.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.bottom)
            $0.right.equalToSuperview().inset(8)
            $0.size.equalTo(32)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(4)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
    }
    
    
    func configureCell(_ movie: Trending) {
        let urlString = NetworkManager.shared.composeURLPath(path: movie.posterPath)
        
        if let url = URL(string: urlString) {
//            posterImageView.kf.setImage(with: url)
            posterImageView.kf.setImage(with: url, completionHandler: { result in
                switch result {
                case .success(let value):
                    let imageSize = value.image.size
                    print("이미지 사이즈: \(imageSize.width) x \(imageSize.height)")
                case .failure(let error):
                    print("이미지 로드 실패: \(error.localizedDescription)")
                }
            })
        }
        
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        movieID = movie.id
        
        let isHearted = HeartManager.shared.isHearted(id: movie.id)
        heartButton.setImage(UIImage(systemName: isHearted ? "heart.fill" : "heart"), for: .normal)
    }
    @objc private func heartButtonTouched() {
        print("heartbutton 탭")
        guard let id = movieID else { return }
        
        if HeartManager.shared.isHearted(id: id) {
            HeartManager.shared.deleteHeart(id: id)
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            HeartManager.shared.createHeart(id: id)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
    }
}
