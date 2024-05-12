//
//  EndPoint.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import Foundation

enum EndPoint {
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    case upcoming
    case topRated
    case popular
    case horror
    case action
    case scifi
    case watchList
    
      func getUrl() -> URL? {
        switch self {
        case .watchList:
            return URL(string: "\(EndPoint.baseURL)/account/21086962/watchlist/movies")
        case .upcoming:
            return URL(string: "\(EndPoint.baseURL)/movie/upcoming")
        case .topRated:
            return URL(string: "\(EndPoint.baseURL)/movie/top_rated")
        case .popular:
            return URL(string: "\(EndPoint.baseURL)/movie/popular")
        case .action:
            return URL(string: "\(EndPoint.baseURL)/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_genres=28")
        case .horror:
            return URL(string: "\(EndPoint.baseURL)/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_genres=27")
        case .scifi:
            return URL(string: "\(EndPoint.baseURL)/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_genres=878")
        }
    }
}
