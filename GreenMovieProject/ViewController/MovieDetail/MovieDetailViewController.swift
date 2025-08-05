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
    
    let movie: Movie
    var cast: [Cast] = []
    var crew: [Crew] = []
    var medios: [Medio] = [] {
        didSet {
            imageCollectionView.reloadData()
            pageControl.numberOfPages = medios.count
        }
    }
    
    var imageCollectionView: UICollectionView!
    let metaHeaderView = MovieMetaView()
    lazy var synopsisView = SynopsisView(text: movie.overview)
    let scrollView = UIScrollView()
    let contentView = UIView()
    var castView: CastListView?
    let pageControl = UIPageControl()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie.title
        updateNavHeartButton()
        configureUI()
        fetchCast()
        fetchImages()
    }
    
    func configureUI() {
        imageCollectionView = createCollectionView()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(metaHeaderView)
        contentView.addSubview(synopsisView)
        
        
        GenreManager.shared.loadGenresIfNeeded {
            let genreNames = GenreManager.shared.top2GenreNames(from: self.movie.genreIds)
            self.metaHeaderView.configureData(
                releaseDate: self.movie.releaseDate,
                rating: self.movie.voteAverage,
                genre: genreNames.joined(separator: ", ")
            )
        }
        
        configureLayout()
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1350.0 / 2400.0)
        }

        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(imageCollectionView)
            make.bottom.equalTo(imageCollectionView).inset(8)
            
        }
        
        metaHeaderView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
        }

        synopsisView.snp.makeConstraints { make in
            make.top.equalTo(metaHeaderView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

    }
    
    func fetchCast() {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.fetchMovieDetail(movieID: self.movie.id) { cast, crew in
                DispatchQueue.main.async {
                    self.cast = cast
                    self.crew = crew
                    
                    let castView = CastListView(cast: cast)
                    self.castView = castView
                    self.contentView.addSubview(castView)
                    
                    castView.snp.makeConstraints {
                        $0.top.equalTo(self.synopsisView.snp.bottom).offset(16)
                        $0.left.right.equalToSuperview().inset(16)
                        $0.bottom.equalToSuperview().inset(20)
                    }
                }
            }
        }
    }
    
    func fetchImages() {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.fetchBackdropImages(movieID: self.movie.id) { medios in
                self.medios = Array(medios.prefix(5))
                for me in self.medios{
                    print("image Size: \(me.width) * \(me.height)")
                }
            }
        }
    }
    
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(BackdropImageCell.self, forCellWithReuseIdentifier: BackdropImageCell.identifier)
        return cv
    }
    
    func updateNavHeartButton() {
        let heartImageName = HeartManager.shared.hasHearted(id: movie.id) ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: heartImageName)
        let heartButton = UIBarButtonItem(image: heartImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(heartButtonClicked))
        heartButton.tintColor = .primary
        navigationItem.rightBarButtonItem = heartButton
    }
    
    @objc  func heartButtonClicked() {
        if HeartManager.shared.hasHearted(id: movie.id) {
            HeartManager.shared.deleteHeart(id: movie.id)
        } else {
            HeartManager.shared.createHeart(id: movie.id)
        }
        updateNavHeartButton()
        NotificationHelper.post(NotificationHelper.updateHeart)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int((scrollView.contentOffset.x + scrollView.frame.width / 2) / scrollView.frame.width) // 반이상 넘겼을 때 페이지를 반영
        
        pageControl.currentPage = pageIndex
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropImageCell.identifier, for: indexPath) as! BackdropImageCell
        cell.configureCell(medios[indexPath.item].filePath)
        return cell
    }
}
