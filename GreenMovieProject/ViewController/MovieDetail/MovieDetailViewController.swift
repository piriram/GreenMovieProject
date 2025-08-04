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
        didSet { imageCollectionView.reloadData() }
    }
    
    var imageCollectionView: UICollectionView!
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
        contentView.addSubview(metaHeaderView)
        contentView.addSubview(synopsisView)
        
        
        GenreManager.shared.loadGenresIfNeeded {
            let genreNames = GenreManager.shared.top3GenreNames(from: self.movie.genreIds)
            self.metaHeaderView.configureData(
                releaseDate: self.movie.releaseDate,
                rating: self.movie.voteAverage,
                genre: genreNames.joined(separator: ", ")
            )
        }
        
        configureLayout()
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(1350.0 / 2400.0) // contentView와 view의 차이?
        }
        
        metaHeaderView.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        synopsisView.snp.makeConstraints {
            $0.top.equalTo(metaHeaderView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
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
            NetworkManager.shared.fetchMovieImages(movieID: self.movie.id) { medios in
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
        cv.register(MediaImageCell.self, forCellWithReuseIdentifier: MediaImageCell.identifier)
        return cv
    }
    
    func updateNavHeartButton() {
        let heartImageName = HeartManager.shared.isHearted(id: movie.id) ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: heartImageName)
        let heartButton = UIBarButtonItem(image: heartImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(heartButtonClicked))
        heartButton.tintColor = .primary
        navigationItem.rightBarButtonItem = heartButton
    }
    
    @objc  func heartButtonClicked() {
        if HeartManager.shared.isHearted(id: movie.id) {
            HeartManager.shared.deleteHeart(id: movie.id)
        } else {
            HeartManager.shared.createHeart(id: movie.id)
        }
        updateNavHeartButton()
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaImageCell.identifier, for: indexPath) as! MediaImageCell
        cell.configureCell(medios[indexPath.item].filePath)
        return cell
    }
}
