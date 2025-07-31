//
//  CinemaViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import Alamofire
import Kingfisher
class CinemaViewController: UIViewController {
    
    static let identifier = "CinemaViewController"
    var movies:[Trending] = []
    lazy var collectionView:UICollectionView = createCollectionView()
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "파이리피디아"
        configureLayout()
        fetchData()
        
    }
    func createCollectionView() -> UICollectionView {
        print(#function)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.minimumLineSpacing = 16
        
        layout.itemSize = CGSize(width: 250, height: 500)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear // 블랙?
        //        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        //        cv.delegate = self
        cv.register(TrendingMovieCell.self, forCellWithReuseIdentifier: TrendingMovieCell.identifier)
        return cv
        
    }
    func configureLayout(){
        print(#function)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(500)
        }
    }
    func fetchData(){
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


