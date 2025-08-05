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
    
    let profileCardView = ProfileCardView()
    let recentSearchView = RecentSearchView()
    
    
    /// 트렌딩 관련 프로퍼티
    let trendingLabel = UILabel()
    lazy var trendingCollectionView:UICollectionView = createTrendingCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "파이리피디아"
        configureUI()
        configureTrendingLayout()
        configureAction()
        
        
        
    }
    
    func configureAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileCardTouched))
        profileCardView.addGestureRecognizer(tap)
        
        goSearchButton()
        fetchTrendingData()
        print("get keywords: \(RecentSearchManager.shared.readKeywords())")
        let keywords: [String] = RecentSearchManager.shared.readKeywords()
        recentSearchView.updateKeywords(keywords)
        recentSearchView.keywordClosure = { [weak self] keyword in
            let vc = SearchViewController()
            vc.initialQuery = keyword
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
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
    func configureProfileCard() {
        profileCardView.configure(
            nickname: UserInfoManager.shared.readNickname() ?? "",
            joinDate: "\(UserInfoManager.shared.readFormattedJoinDate()) 가입",
            boxNum: HeartManager.shared.readHeartCount()
        )
    }
    
    func configureTrendingLayout(){
        //        print(#function)
        
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
        
    }
    func configureUI(){
        view.addSubview(profileCardView)
        view.addSubview(recentSearchView)
        view.addSubview(trendingLabel)
        view.addSubview(trendingCollectionView)
        configureProfileCard()
        
        trendingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        trendingLabel.textColor = .white
        trendingLabel.textAlignment = .left
        trendingLabel.text = "오늘의 영화"
        
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
        NotificationHelper.addObserver(self, selector: #selector(didUpdateNickname), name: NotificationHelper.updateNickname)
        NotificationHelper.addObserver(self, selector: #selector(didUpdateRecentKeyword), name: NotificationHelper.updateRecentKeyword)
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        trendingCollectionView.reloadData()
        print(#function)
    }
    @objc func profileCardTouched() {
        goProfileCard()
    }
    @objc func didUpdateNickname(){
        configureProfileCard()
    }
    @objc func didUpdateRecentKeyword(){
        recentSearchView.reloadKeywords()
    }
}
