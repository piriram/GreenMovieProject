//
//  TrendingView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/9/25.
//

import UIKit
import SnapKit

final class TrendingView: UIView {
    /// 트렌딩 관련 프로퍼티
    let trendingLabel = UILabel()
    lazy var trendingCollectionView:UICollectionView = createTrendingCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        addSubview(trendingLabel)
        addSubview(trendingCollectionView)
        
        trendingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        trendingLabel.textColor = .white
        trendingLabel.textAlignment = .left
        trendingLabel.text = "오늘의 영화"
    }
    
    func configureLayout(){
        trendingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
        }
        
        trendingCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(trendingLabel.snp.bottom).offset(16)
        }
    }
    
    func configureAction(){
        
    }
    
    func createTrendingCollectionView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 16
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear // 블랙?
        cv.showsHorizontalScrollIndicator = false
        return cv
    }
}
