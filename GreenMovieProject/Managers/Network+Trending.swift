//
//  Network+Trending.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//

import UIKit
import Alamofire
extension NetworkManager {
    //TODO: AFError가 무엇인지
    func fetchTrending(completion:@escaping (Result<TrendingResponse, Error>) -> Void){
        let path = "/trending/movie/day"
        
        AF.request(baseURL + path,parameters: parameters ,headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: TrendingResponse.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    print("네트워크 오류 : \(error.localizedDescription)")
                    if let afError = error.asAFError,
                       case let .responseSerializationFailed(reason) = afError ,
                       case let .decodingFailed(decodingError) = reason{
                        print("디코딩 실패:\(decodingError)")
                    }
                    completion(.failure(error))
                }
                
            }
    }
}
