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
    
    func addWatchList(movie: MovieResult) -> AnyPublisher<MovieResponse,Error> {
        let movieRequest = MovieRequest(media_type: "movie", media_id: movie._id, watchlist: true)
        guard let url = URL(string: "https://api.themoviedb.org/3/account/21086962/watchlist") else {
            return Fail(error: ServiceError.badRequest).eraseToAnyPublisher()
        }
        let data = try? JSONEncoder().encode(movieRequest)
        
        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.httpBody = data
        request.allHTTPHeaderFields = headers
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
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
    
    func fetchMovies(endPoint: EndPoint) -> AnyPublisher<MovieListResponse,Error> {
        
        guard let url = endPoint.getUrl() else {
            return Fail(error: ServiceError.badRequest).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: MovieListResponse.self, decoder: JSONDecoder())
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
    
    func searchMovie(query: String) -> AnyPublisher<MovieListResponse, Error>  {
        
        let urlString = "\(EndPoint.baseURL)/search/movie"
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: ServiceError.badRequest).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return session.dataTaskPublisher(for: request)
            .compactMap({ data in
                data.data
            })
            .decode(type: MovieListResponse.self, decoder: JSONDecoder())
            .catch { error in
                Fail(error: error).eraseToAnyPublisher()
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
