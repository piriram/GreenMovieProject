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
    var heartClosure: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        configureAction()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureAction(){
        heartButton.addTarget(self, action: #selector(heartButtonTouched), for: .touchUpInside)
    }
    func configureUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 6
        
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.lineBreakMode = .byTruncatingTail
        
        overviewLabel.textColor = .name
        overviewLabel.font = .systemFont(ofSize: 14)
        overviewLabel.numberOfLines = 3
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .primary
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold))
        config.baseForegroundColor = .primary
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0)
        heartButton.configuration = config
        contentView.addSubview(heartButton)
        
    }
    
    func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.equalToSuperview()
            make.trailing.equalTo(heartButton.snp.leading).offset(-4)
        }
        heartButton.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.right.equalToSuperview().inset(8)
            make.size.equalTo(32)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(4)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-12)
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
        
        let isHearted = HeartManager.shared.hasHearted(id: movie.id)
        heartButton.setImage(UIImage(systemName: isHearted ? "heart.fill" : "heart"), for: .normal)
    }
    @objc private func heartButtonTouched() {
        print("heartbutton 탭")
        guard let id = movieID else { return }
        
        if HeartManager.shared.hasHearted(id: id) {
            HeartManager.shared.deleteHeart(id: id)
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            HeartManager.shared.createHeart(id: id)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        heartClosure?() //nil이 아님 실행
        
    }
}
