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
        //        print(#function)
        super.viewDidLoad()
        navigationItem.title = "파이리피디아"
        configureTrending()
    }
    
    func configureTrending() {
        configureTrendingLayout()
        fetchTrendingData()
    }
    func createTrendingCollectionView() -> UICollectionView {
        //        print(#function)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.minimumLineSpacing = 16
        
        layout.itemSize = CGSize(width: 180, height: 260 )
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear // 블랙?
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(TrendingMovieCell.self, forCellWithReuseIdentifier: TrendingMovieCell.identifier)
        return cv
        
    }
    func configureTrendingLayout(){
        //        print(#function)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(500)
        }
    }
    func fetchTrendingData(){
        
        NetworkManager.shared.fetchTrending{ result in
            switch result{
            case .success(let data):
                //                dump(data)
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
extension CinemaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let vc = MovieDetailViewController(movie: movie)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension CinemaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingMovieCell.identifier, for: indexPath) as! TrendingMovieCell
        let movie = movies[indexPath.item]
        cell.configureCell(movie)
        return cell
    }
}


