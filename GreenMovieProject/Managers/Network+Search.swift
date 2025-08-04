//
//  Network+Search.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Alamofire

extension NetworkManager {
    func fetchSearchResults(query: String, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(baseURL)/search/movie"
        parameters["query"] = query
        parameters["page"] = page
        print("parameters:\(parameters)")
        print("search url:\(url)")
        AF.request(url, method: .get, parameters: self.parameters, headers: headers)
            .validate()
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieList):
                    completion(.success(movieList.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
