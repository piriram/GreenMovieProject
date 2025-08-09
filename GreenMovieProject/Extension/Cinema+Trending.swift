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
            guard let self = self else { return }
            self.configureProfileCard(view: self.profileCardView)
        }
        return cell
    }
}

extension CinemaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         let collectionViewHeight = collectionView.bounds.height
         let textHeight: CGFloat = 90
         let posterHeight = collectionViewHeight - textHeight
         let posterWidth = posterHeight * (2/3)
         return CGSize(width: posterWidth, height: collectionViewHeight)
    }
}



