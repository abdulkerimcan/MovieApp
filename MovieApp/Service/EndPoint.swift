//
//  EndPoint.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import Foundation

enum EndPoint {
    static let baseURL = "https://api.themoviedb.org/3/movie"
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    case upcoming
    case topRated
    case popular
    
      func getUrl() -> URL? {
        switch self {
        case .upcoming:
            return URL(string: "\(EndPoint.baseURL)/upcoming")
        case .topRated:
            return URL(string: "\(EndPoint.baseURL)/toprated")
        case .popular:
            return URL(string: "\(EndPoint.baseURL)/popular")
        }
    }
}