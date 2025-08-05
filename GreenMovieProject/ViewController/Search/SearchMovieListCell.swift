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
    var movieID: Int?
    var isHearted = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        configureUI()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(genreStackView)
        
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        
        
        releaseDateLabel.font = .systemFont(ofSize: 13)
        releaseDateLabel.textColor = .gray
        
        
        genreStackView.axis = .horizontal
        genreStackView.spacing = 4
        genreStackView.alignment = .leading
        
        
        //TODO: - 크기 변경
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .primary
        contentView.addSubview(heartButton)
        
        heartButton.addTarget(self, action: #selector(heartButtonClicked), for: .touchUpInside)
        
        
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
        
        var genreNames:[String] = []
        for id in movie.genreIds {
            if genreMap.keys.contains(id) {
                genreNames.append(genreMap[id]!)
            }
        }
        
        configureGenres(genreNames)
        
        updateHeartButton(movie)
        
    }
    func updateHeartButton(_ movie:Movie){
        self.isHearted = HeartManager.shared.hasHearted(id: movie.id)
        let heartImage = UIImage(systemName: self.isHearted ? "heart.fill" : "heart")
        heartButton.setImage(heartImage, for: .normal)
    }
    
    /// 셀 아래에 장르 태그 3개를 나열하는 설정
    func configureGenres(_ genres: [String]) {
        /// 리유저블 셀에서 기존 장르태그들을 뷰에서 지운다음에
        for genreView in genreStackView.arrangedSubviews{
            genreStackView.removeArrangedSubview(genreView) // input view를 스택뷰의 서브뷰 배열에서 제거
            genreView.removeFromSuperview() // 뷰계층에서 제거하지 않으면 뷰상에 남아서 메모리가 누수될 수 있음
        }
        /// 새로운 태그들을 설정해준다.
        for genre in genres.prefix(3) {
            let label = configureGenreLabel(genre)
            genreStackView.addArrangedSubview(label)
        }
    }
    
    func configureGenreLabel(_ genreTitle:String) -> UILabel{
        let label = PaddingLabel()
        
        label.text = genreTitle
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        
        /// 텍스트 길이에 따라서 늘어남
        /// required > defaultHigh > defaultLow > fittingSizeLevel
        //        label.setContentHuggingPriority(.required, for: .horizontal) // 크기 우선순위(확장 저항?)
        //        label.setContentCompressionResistancePriority(.required, for: .horizontal) // required 압축 저항(줄어들지 않음)
        //
        label.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        return label
    }
    
    @objc private func heartButtonClicked() {
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
