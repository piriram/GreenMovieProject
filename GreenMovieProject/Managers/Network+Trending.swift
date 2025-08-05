//
//  Network+Trending.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import Alamofire
extension NetworkManager {
    //AFError는 알로마파이어의 에러코드를 enum으로 관리하는 것
    func fetchTrending(completion:@escaping (Result<TrendingResponse, Error>) -> Void){
        let path = "/trending/movie/day"
        
        AF.request(baseURL + path,parameters: self.parameters ,headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: TrendingResponse.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    print("트렌딩 네트워크 실패")
                    completion(.failure(error))
                }
                
            }
    }
}
