//
//  SearchViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//
import UIKit
import SnapKit
import Kingfisher

final class SearchViewController: BaseViewController {
    var movies: [Movie] = []
    var genreMap: [Int: String] = [:]
    var initialQuery: String?
    var currentPage = 1
    
    let searchBar = UISearchBar()
    
    // 뷰 컨트롤러 내부 함수를 쓰려면 지연 속성으로 지정해야함 왜냐면 인스턴스 메서드이기 떄문에 static 으로 선언하는 방법이 있음
    lazy var collectionView = self.createCollectionView()
    
    lazy var emptyView = EmptyMessageView(message: "원하는 검색 결과를 찾지 못했습니다.")
    var isSearch = false // 검색하는 경우면 테이블뷰 포커스를 상단으로 올림
    var beforeKeyword = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "영화 검색"
        configureUI()
        configureLayout()
        
        if let query = initialQuery {
            searchBar.text = query
            print("fetch data 실행 view did load")
            fetchData(query: query)
        } else {
            
            searchBar.becomeFirstResponder()
        }
        emptyView.hide()
    }
    
    func fetchData(query: String,isAppend: Bool = false) {
        
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.fetchSearchResults(query: query, page: currentPage) { result in
            switch result {
            case .success(let movies):
                if isAppend{
                    self.movies.append(contentsOf: movies)
                }else{
                    self.movies = movies
                }
                RecentSearchManager.shared.createKeyword(query)
                NotificationHelper.post(NotificationHelper.updateRecentKeyword)
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
        
        // 두개의 데이터를 모두 가져오면, 그때 뷰를 그린다.
        group.notify(queue: .main) {
            if self.isSearch{//검색내용이 있던 상황이면
                self.collectionView.setContentOffset(.zero, animated: false) //스크롤을 위로 올리기
                self.isSearch = false
            }
            /// 비어있는 레이블 -> 처음에 is hidden == false
            /// 검색되면 그때 true
            /// 또 검색하면 그때 true
            ///
            if self.movies.isEmpty {
                self.emptyView.show()
            }
            else{
                self.emptyView.hide()
            }
            print(#function)
            self.collectionView.reloadData()
        }
    }
    
    func configureUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.searchBarStyle = .minimal
        // TODO: 플레이스 홀더 색을 더 밝게
        searchBar.placeholder = "영화를 검색해보세요."
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        
        
        
        //        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: 140)
        //        layout.minimumLineSpacing = 10
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        collectionView.frame = .zero
        //        collectionView.collectionViewLayout = layout
        //
        //
        //        collectionView.backgroundColor = .clear
        //        collectionView.register(SearchMovieListCell.self, forCellWithReuseIdentifier: SearchMovieListCell.identifier)
        
        
    }
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 140)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(SearchMovieListCell.self, forCellWithReuseIdentifier: SearchMovieListCell.identifier)
        return cv
    }
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
        }
    }
//    
//    func showEmptyUI() {
//        movies = []
//        emptyView.show()
//        print(#function)
//        collectionView.reloadData()
//        
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationHelper.addObserver(self, selector: #selector(updateHeart), name: NotificationHelper.updateHeart)
    }
    //TODO: 해당셀만 업데이트 해보기
    @objc func updateHeart(){
        print(#function)
        collectionView.reloadData()
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespaces), !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        currentPage = 1
        isSearch = true
        print("fetch data 실행 : searchbar clicked")
        fetchData(query: query)
    }
}

extension SearchViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < movies.count else {
            print("인덱스 : \(indexPath.item), movies.count: \(movies.count)")
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchMovieListCell.identifier, for: indexPath) as! SearchMovieListCell
        
        
        let movie = movies[indexPath.item]
        cell.configureData(movie: movie, genreMap: genreMap)
        
        let genreNames = movie.genreIds.compactMap { genreMap[$0] }
        cell.configureGenres(genreNames)
        
        if indexPath.item == movies.count - 10{
            if let query = searchBar.text, !query.isEmpty {
                currentPage += 1
                print("fetch data 실행 - 페이지네이션")
                fetchData(query: query,isAppend: true)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        let detailVC = MovieDetailViewController(movie: selectedMovie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
