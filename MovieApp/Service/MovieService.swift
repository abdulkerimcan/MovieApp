//
//  MovieService.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import Foundation

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
    
    func fetchMovies<T:Codable>(type: T.Type, endPoint: EndPoint, completion: @escaping (Result<T,Error>) -> ()) {
        guard let url = endPoint.getUrl() else {
            completion(.failure(ServiceError.badRequest))
            return
        }
        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(ServiceError.badRequest))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.dataError))
                return
            }
            do {
                let datas = try JSONDecoder().decode(T.self, from: data)
                completion(.success(datas))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: "\(EndPoint.imageURL)\(urlString)") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            completion(data)
            
        }
        
        task.resume()
    }
    
}
