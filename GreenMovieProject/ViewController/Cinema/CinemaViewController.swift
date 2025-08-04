//
//  CinemaViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import Alamofire
import Kingfisher
//TODO: - 하위 뷰 만들어서 관리하기
class CinemaViewController:BaseViewController {
    
    static let identifier = "CinemaViewController"
    var trendings:[Trending] = []
    let width:Double = 250
    let profileCardView = ProfileCardView()
    let recentSearchView = RecentSearchView()
    
    
    /// 트렌딩 관련 프로퍼티
    let trendingLabel = UILabel()
    lazy var trendingCollectionView:UICollectionView = createTrendingCollectionView()
    
    override func viewDidLoad() {
        //        print(#function)
        super.viewDidLoad()
        navigationItem.title = "파이리피디아"
        configureAll()
        
        print("get keywords: \(RecentSearchManager.shared.getKeywords())")
        let keywords: [String] = RecentSearchManager.shared.getKeywords()
        
        recentSearchView.updateKeywords(keywords)
        recentSearchView.onKeywordClosure = { [weak self] keyword in
            let vc = SearchViewController()
            vc.initialQuery = keyword
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
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
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.minimumLineSpacing = 16
        
        //        layout.itemSize = CGSize(width: width, height: width * 1.5 )
        
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
        view.addSubview(profileCardView)
        view.addSubview(recentSearchView)
        view.addSubview(trendingLabel)
        view.addSubview(trendingCollectionView)
        
        profileCardView.snp.makeConstraints { make in
            
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(96)
        }
        recentSearchView.snp.makeConstraints { make in
            make.top.equalTo(profileCardView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(92)
        }
        trendingLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(17)
        }
        trendingCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(trendingLabel.snp.bottom).offset(16)
        }
        profileCardView.configure(
            nickname: UserInfoManager.shared.readNickname() ?? "",
            joinDate: "\(UserInfoManager.shared.getFormattedJoinDate()) 가입",
            boxNum: HeartManager.shared.heartCount()
        )
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileCardTouched))
        profileCardView.addGestureRecognizer(tap)
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
                self.trendings = data.results
                
                DispatchQueue.main.async {
                    self.trendingCollectionView.reloadData()
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
            action: #selector(searchButtonClicked)
        )
        searchButton.tintColor = .primary
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func searchButtonClicked() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recentSearchView.reloadKeywords()
        trendingCollectionView.reloadData()
        print(#function)
    }
    @objc func profileCardTouched() {
        goProfileCard()
    }
 
    
    
    
}
extension CinemaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let trending = trendings[indexPath.item]
        let movie = Movie(id: trending.id, title: trending.title, posterPath: trending.posterPath, releaseDate: trending.releaseDate, voteAverage: trending.voteAverage, overview: trending.overview, genreIds: trending.genreIds)
        let vc = MovieDetailViewController(movie: movie)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension CinemaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return trendings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingMovieCell.identifier, for: indexPath) as! TrendingMovieCell
        let movie = trendings[indexPath.item]
        cell.configureCell(movie)
        return cell
    }
}

extension CinemaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let topSafeArea = view.safeAreaInsets.top
        print("topSafeArea: \(topSafeArea)")
        let bottomSafeArea = view.safeAreaInsets.bottom
        print("bottomSafeArea: \(bottomSafeArea)")
        
        let fixedComponentHeight: CGFloat = topSafeArea + bottomSafeArea + 261 + 60
        let availableHeight = view.bounds.height - fixedComponentHeight
        //UIScreen?

        let fixedTextHeight: CGFloat = 84  // poster 아래 spacing 포함

        let posterHeight = availableHeight - fixedTextHeight
        
        let posterWidth = posterHeight * (500 / 716)
        
        return CGSize(width: posterWidth, height: availableHeight)
    }
}

