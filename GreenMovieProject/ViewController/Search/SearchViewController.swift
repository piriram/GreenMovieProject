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
    var isLoading = false
    var hasMoreData = true
    
    let searchBar = UISearchBar()
    var collectionView: UICollectionView!
    let emptyLabel = UILabel()
    
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
        isLoading = true
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.fetchSearchResults(query: query, page: currentPage) { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                self.hasMoreData = movies.count == 20
            case .failure(let error):
                print("검색 실패: \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.fetchGenres { genre in
            self.genreMap = genre
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
            self.emptyLabel.isHidden = !self.movies.isEmpty
            self.isLoading = false
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
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
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
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
        fetchData(query: query)
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
        
        let genreNames = movie.genreIds.compactMap { genreMap[$0] }
        cell.configureGenres(genreNames)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height - 100 {
            guard !isLoading, hasMoreData, let query = searchBar.text else { return }
            currentPage += 1
            fetchData(query: query)
        }
    }
}
