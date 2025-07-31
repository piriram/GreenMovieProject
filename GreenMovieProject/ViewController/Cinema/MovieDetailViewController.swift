//
//  MovieDetailViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import Alamofire

class MovieDetailViewController: BaseViewController {

    let movie:Trending
    var cast: [Cast] = []
    var crew: [Crew] = []
    
    init(movie: Trending) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(movie.title)"
        
        
        NetworkManager.shared.fetchMovieDetail(movieID: movie.id){ cast, crew in
            self.cast = cast
            self.crew = crew
            dump(self.cast)
            
//            DispatchQueue.main.async {
//                
//            }
            
        }
    }

    
}
