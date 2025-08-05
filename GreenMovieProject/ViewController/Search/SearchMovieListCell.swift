//
//  MovieCell.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//
import UIKit
import SnapKit
import Kingfisher

final class SearchMovieListCell: UICollectionViewCell {
    static let identifier = "MovieCell"
    
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let releaseDateLabel = UILabel()
    let genreStackView = UIStackView()
    let heartButton = UIButton()
    private var movieID: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        configureUI()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        contentView.addSubview(posterImageView)
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        releaseDateLabel.font = .systemFont(ofSize: 13)
        releaseDateLabel.textColor = .gray
        contentView.addSubview(releaseDateLabel)
        
        genreStackView.axis = .horizontal
        genreStackView.spacing = 4
        genreStackView.alignment = .leading
        contentView.addSubview(genreStackView)
        
        //TODO: - 크기 변경
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .primary
        contentView.addSubview(heartButton)
        
        heartButton.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
        
        
    }
    
    func configureLayout() {
        posterImageView.snp.makeConstraints {
            $0.left.verticalEdges.equalToSuperview().inset(8)
            $0.width.equalTo(posterImageView.snp.height).multipliedBy(0.7)
            
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.top).offset(4)
            $0.left.equalTo(posterImageView.snp.right).offset(12)
            $0.right.equalTo(heartButton.snp.left).offset(-8)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(titleLabel.snp.left)
        }
        
        genreStackView.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView.snp.bottom)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.lessThanOrEqualToSuperview().inset(40)
        }
        
        heartButton.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView.snp.bottom)
            $0.right.equalToSuperview().inset(8)
            $0.size.equalTo(32)
        }
    }
    
    func configureData(movie: Movie, genreMap: [Int: String]) {
        movieID = movie.id
        titleLabel.text = movie.title
        
        let dateStr = movie.releaseDate
        releaseDateLabel.text = dateStr.isEmpty ? "개봉일 미정" : dateStr.replacingOccurrences(of: "-", with: ". ")
        
        if let posterPath = movie.posterPath {
            let url = URL(string: NetworkManager.shared.composeURLPath(path: posterPath))
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
        
        let genreNames = movie.genreIds.compactMap { data in
            genreMap[data]
        }
        configureGenres(genreNames)
        let isHearted = HeartManager.shared.hasHearted(id: movie.id)
        let heartImage = UIImage(systemName: isHearted ? "heart.fill" : "heart")
        heartButton.setImage(heartImage, for: .normal)
        
    }
    
    func configureGenres(_ genres: [String]) {
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for genre in genres.prefix(3) {
            let label = PaddingLabel()
            label.text = genre
            label.font = .systemFont(ofSize: 11, weight: .medium)
            label.textColor = .white
            label.textAlignment = .center
            label.backgroundColor = .darkGray
            label.layer.cornerRadius = 4
            label.clipsToBounds = true
            
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            label.snp.makeConstraints {
                $0.height.equalTo(20)
            }
            
            genreStackView.addArrangedSubview(label)
        }
    }
    @objc private func didTapHeart() {
        guard let id = movieID else { return }
        
        if HeartManager.shared.hasHearted(id: id) {
            HeartManager.shared.deleteHeart(id: id)
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            HeartManager.shared.createHeart(id: id)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    
}
