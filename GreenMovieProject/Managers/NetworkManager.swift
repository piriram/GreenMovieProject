//
//  NetworkManager.swift
//  GreenMovieProject
//
//  Created by piri kim on 7/31/25.
//
//MARK: 나중에 TMDBManager로 이름바꿀 예정
//TODO: 나중에 속성에 private 다 붙이기
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let baseURL = "https://api.themoviedb.org/3"
    let headers: HTTPHeaders = [
        "Authorization":"Bearer \(APIKey.APIKey)"
    ]
    var parameters: Parameters = ["language":"ko-KR"] //"include_image_language":null
    
   
   
    func fetchMovieImages(movieID:Int,completion:@escaping ([Medio])->Void){
        parameters["include_image_language"] = "null"
        let path = "/movie/\(movieID)/images"
        print(baseURL + path)
        AF.request(baseURL + path,parameters: parameters ,headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: MedioResponse.self) { response in
                
                switch response.result {
                case .success(let value):
                    completion(value.backdrops)
                case .failure(let error):
                    print("네트워크 오류 : \(error.localizedDescription)")
                    if let afError = error.asAFError,
                       case let .responseSerializationFailed(reason) = afError ,
                       case let .decodingFailed(decodingError) = reason{
                        print("디코딩 실패:\(decodingError)")
                    }
                    
                }
                
            }
    }
}
