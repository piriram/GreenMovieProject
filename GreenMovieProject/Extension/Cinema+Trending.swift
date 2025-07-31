//
//  Cinema+Trending.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
/// 트렌딩 관련 함수들 모아놓기
extension CinemaViewController{
    func configureTrending() {
        configureTrendingLayout()
        fetchTrendingData()
    }
    func createTrendingCollectionView() -> UICollectionView {
        print(#function)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.minimumLineSpacing = 16
        
        layout.itemSize = CGSize(width: 180, height: 270 )
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear // 블랙?
        //        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        //        cv.delegate = self
        cv.register(TrendingMovieCell.self, forCellWithReuseIdentifier: TrendingMovieCell.identifier)
        return cv
        
    }
    func configureTrendingLayout(){
        print(#function)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(500)
        }
    }
    func fetchTrendingData(){
        print(#function)
        NetworkManager.shared.fetchTrending{ result in
            switch result{
            case .success(let data):
                dump(data)
                self.movies = data.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
}
