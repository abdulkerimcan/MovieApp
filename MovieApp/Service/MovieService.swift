//
//  MovieService.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import Foundation
import Combine

enum ServiceError: Error {
    case badRequest
    case dataError
}

final class MovieService {
    static let shared = MovieService()
    private let session = URLSession.shared
    let headers = [
        "accept": "application/json",
        "Authorization": "Bearer \(Constants.shared.token)"
    ]
    private init() { }
    
    func fetchMovies<T:Codable>(type: T.Type, endPoint: EndPoint) -> AnyPublisher<T,Error> {
        
        guard let url = endPoint.getUrl() else {
            return Fail(error: ServiceError.badRequest).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case is URLError:
                    return error
                case is DecodingError:
                    return error
                default:
                    return ServiceError.dataError
                }
            }
            .eraseToAnyPublisher()
    }
    
    func downloadImage(from urlString: String) -> AnyPublisher<Data,Error> {
        guard let url = URL(string: "\(EndPoint.imageURL)\(urlString)") else {
            return Fail(error: ServiceError.badRequest).eraseToAnyPublisher()
            
        }
        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return session.dataTaskPublisher(for: request)
            .catch { error in
                return Fail(error: error)
            }
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .eraseToAnyPublisher()

    }
}
