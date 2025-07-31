//
//  MovieMetaView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import SnapKit

final class MovieMetaView: UIView {
    let releaseDateIcon = UIImageView()
    let releaseDateLabel = UILabel()
    
    let ratingIcon = UIImageView()
    let ratingLabel = UILabel()
    
    let genreIcon = UIImageView()
    let genreLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureUI() {
        // TODO: 왜 view.나 contentView.이 아니지?
        backgroundColor = .yellow
        releaseDateIcon.image = UIImage(systemName: "calendar")
        ratingIcon.image = UIImage(systemName: "star.fill")
        genreIcon.image = UIImage(systemName: "film")
        
        
    }
    
    
}
