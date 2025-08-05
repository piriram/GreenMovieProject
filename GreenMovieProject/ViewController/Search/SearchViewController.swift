//
//  SearchViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//
import UIKit
import SnapKit
import Kingfisher

final class SearchViewController: UIViewController {
    var movies: [Movie] = []
    var genreMap: [Int: String] = [:]
    var initialQuery: String?
    var currentPage = 1
    
    let searchBar = UISearchBar()
    var collectionView: UICollectionView!
    let emptyLabel = UILabel()
    var isSearch = false // 검색하는 경우면 테이블뷰 포커스를 상단으로 올림
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "영화 검색"
        configureUI()
        configureLayout()
        
        if let query = initialQuery {
            searchBar.text = query
            fetchData(query: query)
        } else {
            showEmptyUI()
            searchBar.becomeFirstResponder()
        }
    }
    
    func fetchData(query: String) {
        
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.fetchSearchResults(query: query, page: currentPage) { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                RecentSearchManager.shared.createKeyword(query)
            case .failure(let error):
                print("검색 실패: \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.enter()
        GenreManager.shared.loadGenresIfNeeded {
            self.genreMap = GenreManager.shared.genreMap /// private로 바꾸고 함수로 가져오기
            group.leave()
        }
        //        NetworkManager.shared.fetchGenres { genre in
        //            self.genreMap = genre
        //            group.leave()
        //        }
        //        
        group.notify(queue: .main) {
            if self.isSearch{
                self.collectionView.setContentOffset(.zero, animated: false) //스크롤을 위로 올리기
                self.isSearch = false
            }
            self.collectionView.reloadData()
            self.emptyLabel.isHidden = !self.movies.isEmpty
            
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
        
        searchBar.delegate = self
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "영화를 검색해보세요."
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        view.addSubview(searchBar)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: 140)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.register(SearchMovieListCell.self, forCellWithReuseIdentifier: SearchMovieListCell.identifier)
        view.addSubview(collectionView)
        
        emptyLabel.text = "원하는 검색결과를 찾지 못했습니다"
        emptyLabel.font = .systemFont(ofSize: 14)
        emptyLabel.textColor = .lightGray
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func showEmptyUI() {
        movies = []
        collectionView.reloadData()
        emptyLabel.isHidden = false
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespaces), !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        currentPage = 1
        isSearch = true
        fetchData(query: query)
    }
}

extension SearchViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchMovieListCell.identifier, for: indexPath) as! SearchMovieListCell
        
        
        let movie = movies[indexPath.item]
        cell.configureData(movie: movie, genreMap: genreMap)
        
        let genreNames = movie.genreIds.compactMap { genreMap[$0] }
        cell.configureGenres(genreNames)
        
        if indexPath.item == movies.count - 10{
            if let query = searchBar.text, !query.isEmpty {
                currentPage += 1
                fetchData(query: query)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select item")
        let selectedMovie = movies[indexPath.item]
        let detailVC = MovieDetailViewController(movie: selectedMovie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
