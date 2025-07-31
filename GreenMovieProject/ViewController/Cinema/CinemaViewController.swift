//
//  CinemaViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import Alamofire
import Kingfisher
class CinemaViewController:BaseViewController {
    
    static let identifier = "CinemaViewController"
    var movies:[Trending] = []
    
    /// 트렌딩 관련 프로퍼티
    lazy var collectionView:UICollectionView = createTrendingCollectionView()
    
    
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        navigationItem.title = "파이리피디아"
        configureTrending()
    }
   
}

extension CinemaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingMovieCell.identifier, for: indexPath) as! TrendingMovieCell
        let movie = movies[indexPath.item]
        cell.configureCell(movie)
        return cell
    }
}


