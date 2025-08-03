//
//  MovieDetailViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import Alamofire
import Kingfisher

class MovieDetailViewController: BaseViewController {
    
    let movie:Movie
    
    var cast: [Cast] = []
    var crew: [Crew] = []
    var medios: [Medio] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var collectionView: UICollectionView!
    let metaHeaderView = MovieMetaView()
    lazy var synopsisView = SynopsisView(text: movie.overview)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var castView: CastListView?
    
    
    init(movie: Movie) {
        self.movie = movie
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(movie.title)"
        configureAll()
        
        
        
    }
    func configureAll(){
        fetchData()
        configureUI()
        configureLayout()
        configureRightHeartButton() 
        
    }
    func configureUI(){
        
        collectionView = createCollectionView()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(metaHeaderView)
        contentView.addSubview(synopsisView)
        
        
    }
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // 수직 스크롤을 위한 고정 폭
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
        
        metaHeaderView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        synopsisView.snp.makeConstraints { make in
            make.top.equalTo(metaHeaderView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    
    func fetchData(){
        DispatchQueue.global(qos: .background).async {
            
            
            NetworkManager.shared.fetchMovieDetail(movieID: self.movie.id) { cast, crew in
                DispatchQueue.main.async {
                    self.cast = cast
                    self.crew = crew
                    
                    let castView = CastListView(cast: cast)
                    self.castView = castView
                    self.contentView.addSubview(castView)
                    
                    castView.snp.makeConstraints { make in
                        make.top.equalTo(self.synopsisView.snp.bottom).offset(16)
                        make.left.right.equalToSuperview().inset(16)
                        make.bottom.equalToSuperview().inset(20)
                    }
                }
            }
            
        }
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.fetchMovieImages(movieID: self.movie.id) { medios in
                self.medios = Array(medios.prefix(5)) //TODO: ??
                print("medios Count: \(self.medios.count)")
            }
        }
        
    }
    
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MediaImageCell.self, forCellWithReuseIdentifier: MediaImageCell.identifier)
        return collectionView
    }
    //TODO: 딥다이빙
    func createPageControl() -> UIPageControl {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .gray
        return pc
    }
    private func configureRightHeartButton() {
        let heartImageName = FavoriteManager.shared.isHearted(id: movie.id) ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: heartImageName)
        let heartButton = UIBarButtonItem(image: heartImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapHeartButton))
        heartButton.tintColor = .primary // 원하는 색상 지정
        navigationItem.rightBarButtonItem = heartButton
    }
    @objc private func didTapHeartButton() {
        if FavoriteManager.shared.isHearted(id: movie.id) {
            FavoriteManager.shared.removeHeartedMovie(id: movie.id)
        } else {
            FavoriteManager.shared.saveHeartedMovie(id: movie.id)
        }

        // 버튼 상태 업데이트
        configureRightHeartButton()
    }


    
    
}
extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(5, medios.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaImageCell.identifier, for: indexPath) as! MediaImageCell
        cell.configureCell(medios[indexPath.item].filePath)
        return cell
    }
    
    
    
}



