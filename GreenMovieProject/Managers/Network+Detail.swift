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
        AF.request(baseURL + path,parameters: parameters ,headers: headers)
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
    
    //MARK: 무엇을 하는 함수인가요?
    func composeURLPath(path:String)->String{
        return "https://image.tmdb.org/t/p/w500" + path
    }
}
