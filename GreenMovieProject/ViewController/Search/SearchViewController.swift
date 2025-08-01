//
//  SearchViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//
import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    var movies: [Movie] = []
    let searchBar = UISearchBar()
    let resultCountLabel = UILabel()
    var collectionView: UICollectionView!
    var genreMap: [Int: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "영화 검색"
        configureAll()
        
    }
    func fetchData(){
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.fetchSearchResults(query: "어벤져스") { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                print("검색 성공")
            case .failure(let error):
                print("검색 실패: \(error.localizedDescription)")
            }
            group.leave()
        }
        group.enter()
        NetworkManager.shared.fetchGenres { genre in
            self.genreMap = genre
            //            dump(genre)
            print("fetch genre 종료")
            group.leave()
            
        }
        group.notify(queue: .main) {
            self.resultCountLabel.text = "검색 결과 \(self.movies.count)개"
            self.collectionView.reloadData()
        }
        
        
    }
    func configureUI() {
        configureSearchBar()
        configureResultLabel()
        configureCollectionView()
    }
    
    func configureAll() {
        fetchData()
        configureUI()
        configureLayout()
    }
    
    func configureSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .white
        view.addSubview(searchBar)
    }
    
    func configureResultLabel() {
        resultCountLabel.text = "검색 결과 0개"
        resultCountLabel.textColor = .white
        resultCountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        view.addSubview(resultCountLabel)
    }
    
    func configureCollectionView() {
        collectionView = makeCollectionView()
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier) // 위치?
        
    }
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: 140)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        resultCountLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(resultCountLabel.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = movies[indexPath.item]
        cell.configureData(movie: movie, genreMap: genreMap)
        
        return cell
    }
    
}
