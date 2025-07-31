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
    
    private init() {}
    
    let baseURL = "https://api.themoviedb.org/3"
    let headers: HTTPHeaders = [
        "Authorization":"Bearer \(APIKey.APIKey)"
    ]
    
//    func fetchTrending(completion:){
//        let path = "/trending/movie/day"
//        AF.request(baseURL + path, headers: headers)
//            .validate(statusCode: 200..<300)
//            .responseDecodable(of: MovieListResponse.self) { response in
//                
//            }
//    }
}
