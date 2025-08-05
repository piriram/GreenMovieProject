//
//  Network+Detail.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Alamofire

extension NetworkManager {
  
    func fetchMovieDetail(movieID:Int,completion:@escaping ([Cast], [Crew])->Void){
        let path = "/movie/\(movieID)/credits"
        print(baseURL + path)
//        let parameters: [String: Any] = ["language":"ko-KR"]
//        print("parameters : \(parameters)")
        AF.request(baseURL + path,parameters: self.parameters ,headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CreditsResponse.self) { response in
                
                switch response.result {
                case .success(let value):
                    completion(value.cast, value.crew)
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
