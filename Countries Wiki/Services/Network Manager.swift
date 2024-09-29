//
//  Network Manager.swift
//  Countries wiki
//
//  Created by user246073 on 9/29/24.
//

import Foundation
import Alamofire

enum Link {
    case countryURL
    
    var url: URL {
        switch self {
        case .countryURL:
            return URL(string: "https://restcountries.com/v3.1/all")!
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCountries(from url: URL, completion: @escaping(Result<[Country], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let country = Country.getCountry(from: value)
                    completion(.success(country))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchData(from url: String, completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { dataResponse  in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
