//
//  Network+Genre.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Alamofire

extension NetworkManager {
    func fetchGenres(completion: @escaping ([Int: String]) -> Void) {
        let url = "\(baseURL)/genre/movie/list"
        
        AF.request(url, parameters: self.parameters, headers: headers)
            .validate()
            .responseDecodable(of: GenreListResponse.self) { response in
                switch response.result {
                case .success(let result):
                    let genreDict = Dictionary(uniqueKeysWithValues: result.genres.map { ($0.id, $0.name) })
                    completion(genreDict)
                case .failure(let error):
                    print("장르 로드 실패: \(error.localizedDescription)")
                    completion([:])
                }
            }
    }
}
