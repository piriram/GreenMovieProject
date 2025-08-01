//
//  NetworkManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//
//MARK: 나중에 TMDBManager로 이름바꿀 예정
//TODO: 나중에 속성에 private 다 붙이기
import UIKit
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
   
    
    func fetchGenres(completion: @escaping ([Int: String]) -> Void) {
           let url = "\(baseURL)/genre/movie/list"
           let parameters: Parameters = ["language": "ko-KR"]
           
           AF.request(url, parameters: parameters, headers: headers)
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
    private init() {}
    
    let baseURL = "https://api.themoviedb.org/3"
    let headers: HTTPHeaders = [
        "Authorization":"Bearer \(APIKey.APIKey)"
    ]
    var parameters: Parameters = ["language":"ko-KR"] //"include_image_language":null
    func fetchSearchResults(query: String, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(baseURL)/search/movie"
        
        parameters["query"] = query
        parameters["page"] = page
        print("parameters:\(parameters)")
        print("search url:\(url)")
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let movieList):
                    completion(.success(movieList.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
