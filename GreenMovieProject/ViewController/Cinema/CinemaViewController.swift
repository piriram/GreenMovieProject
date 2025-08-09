//
//  CinemaViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import Alamofire
import Kingfisher
// TODO: - 하위 뷰 만들어서 관리하기
// TODO: 예외처리 생각해서 공수 산정하기
class CinemaViewController:BaseViewController {
    
    static let identifier = "CinemaViewController"
    var trendings:[Trending] = []
    let profileCardView = ProfileCardView()
    let recentSearchView = RecentSearchView()
    let trendingView = TrendingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "파이리피디아"
        trendingView.trendingCollectionView.delegate = self
        trendingView.trendingCollectionView.dataSource = self
        trendingView.trendingCollectionView.register(TrendingMovieCell.self, forCellWithReuseIdentifier: TrendingMovieCell.identifier)
        configureUI()
        configureLayout()
        configureAction()
    }
    
    private func configureUI(){
        view.addSubview(profileCardView)
        view.addSubview(recentSearchView)
        view.addSubview(trendingView)
        
        configureProfileCard(view: profileCardView)
    }
    
    private func configureLayout(){
        profileCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(100)
        }
       
        recentSearchView.snp.makeConstraints { make in
            make.top.equalTo(profileCardView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(92)
        }
        
        trendingView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileCardTouched))
        profileCardView.addGestureRecognizer(tap)
        configureNav()
        fetchTrendingData()
        let keywords: [String] = RecentSearchManager.shared.readKeywords()
        recentSearchView.updateKeywords(keywords)
        recentSearchView.keywordClosure = { [weak self] keyword in
            let vc = SearchViewController()
            vc.initialQuery = keyword
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func fetchTrendingData(){
        NetworkManager.shared.fetchTrending{ result in
            switch result{
            case .success(let data):
                self.trendings = data.results
                DispatchQueue.main.async {
                    self.trendingView.trendingCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 검색 버튼을 설정함
    private func configureNav() {
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonClicked)
        )
        searchButton.tintColor = .primary
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func searchButtonClicked() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }

    // MARK: - Notification 관련 메서드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createObservers()
    }
    
    private func createObservers() {
        NotificationHelper.addObserver(self, selector: #selector(didUpdateNickname), name: NotificationHelper.updateNickname)
        NotificationHelper.addObserver(self, selector: #selector(didUpdateRecentKeyword), name: NotificationHelper.updateRecentKeyword)
        NotificationHelper.addObserver(self, selector: #selector(didUpdateHeart), name: NotificationHelper.updateHeart)
    }

    @objc func profileCardTouched() { goProfileCard() }
    
    @objc func didUpdateNickname(){ configureProfileCard(view: profileCardView) }
    
    @objc func didUpdateHeart(){ configureProfileCard(view: profileCardView) }
    
    @objc private func didUpdateRecentKeyword(){ recentSearchView.reloadKeywords() }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deleteObservers()
    }
    
    private func deleteObservers() { NotificationHelper.removeAllObservers(self) }
}
