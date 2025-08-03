//
//  FavoriteManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/3/25.
//

import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    private let key = "heart"

    private init() {}

    func saveHeartedMovie(id: Int) {
        var ids = loadHeartedMovies()
        guard !ids.contains(id) else { return }
        ids.append(id)
        UserDefaults.standard.set(ids, forKey: key)
    }

    func removeHeartedMovie(id: Int) {
        var ids = loadHeartedMovies()
        ids.removeAll { $0 == id }
        UserDefaults.standard.set(ids, forKey: key)
    }

    func loadHeartedMovies() -> [Int] {
        return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }

    func isHearted(id: Int) -> Bool {
        return loadHeartedMovies().contains(id)
    }
}
