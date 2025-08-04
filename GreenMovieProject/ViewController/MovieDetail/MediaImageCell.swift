//
//  MediaImageCell.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import Kingfisher
//TODO: 높이 맞추기 (비율로)
final class MediaImageCell: UICollectionViewCell {
    static let identifier = "MediaImageCell"
    
    let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(_ path: String) {
        contentView.backgroundColor = .black
        let baseURL = NetworkManager.shared.composeURLPath(path: path)
        if let url = URL(string: baseURL) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

