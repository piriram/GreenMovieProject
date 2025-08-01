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
    let width:Double = 140

    /// 트렌딩 관련 프로퍼티
    let trendingLabel = UILabel()
    lazy var trendingCV:UICollectionView = createTrendingCollectionView()
    
    override func viewDidLoad() {
        //        print(#function)
        super.viewDidLoad()
        navigationItem.title = "파이리피디아"
        configureAll()
         
            print("get keywords: \(RecentSearchManager.shared.getKeywords())")
        
    }
    
    func configureAll() {
        configureTrendingLayout()
        goSearchButton()
        fetchTrendingData()
    }
    func createTrendingCollectionView() -> UICollectionView {
        //        print(#function)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.minimumLineSpacing = 16
        
        layout.itemSize = CGSize(width: width, height: width * 1.5 )
        
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
        view.addSubview(trendingLabel)
        view.addSubview(trendingCV)
        trendingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide).offset(300)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(17)
        }
        trendingCV.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(trendingLabel.snp.bottom)
        }
        
        trendingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        trendingLabel.textColor = .white
        trendingLabel.textAlignment = .left
        trendingLabel.text = "오늘의 영화"
        print("트렌딩레이블")
    }
    func fetchTrendingData(){
        
        NetworkManager.shared.fetchTrending{ result in
            switch result{
            case .success(let data):
                //                dump(data)
                self.movies = data.results
                DispatchQueue.main.async {
                    self.trendingCV.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    func goSearchButton() {
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapSearchButton)
        )
        searchButton.tintColor = .primary
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func didTapSearchButton() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
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


