//
//  Cinema+Trending.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit

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
        cell.heartClosure = { [weak self] in
            self?.configureProfileCard()
            
        }
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



