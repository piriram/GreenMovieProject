//
//  Network+Detail.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import Alamofire

extension NetworkManager {
    // 크레딧 == 무비디테일
    func fetchMovieDetail(movieID:Int,completion:@escaping ([Cast], [Crew])->Void){
        let path = "/movie/\(movieID)/credits"
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
    
    func fetchBackdropImages(movieID:Int,completion:@escaping ([Medio])->Void){
        parameters["include_image_language"] = "null" // 여기서만 새로 파라미터를 생성해서 씀,이미지는 언어 쿼리가 없음
        let path = "/movie/\(movieID)/images"

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
